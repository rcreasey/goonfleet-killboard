class Kill < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 50
  
  has_many :pilots
  
  validates_presence_of :killmail
  validates_uniqueness_of :killmail, :message => 'already exists in the database.'
  validates_associated :pilots
  
  acts_as_ferret :fields => {
    :victim_details => {},
    :victors_details => {},
    :players => {},
    :corporations => {},
    :alliances => {},
    :ships => {},
    :solar_system => {},
    :region => {},
    :date => {:index => :untokenized_omit_norms, :term_vector => :no}
  }
  
  ## index methods
  def victim_details
    self.victim.details
  end
  
  def victors_details
    self.victors.map {|v| v.details }.join(';')
  end
  
  def players
    self.pilots.map {|p| p.name}.join(',')
  end
  
  def corporations
    self.pilots.map {|p| p.corporation_name}.join(',')
  end
  
  def alliances
    self.pilots.map {|p| p.alliance_name}.join(',')
  end
  
  def ships
    self.pilots.map {|p| p.ship.name}.join(',')
  end
  
  def solar_system
    self.victim.solar_system.name
  end
  
  def region
    self.victim.solar_system.region.name
  end
  
  def date
    self.posted.to_i
  end
  
  ## shortcut methods
  def victim
    self.pilots.find_by_is_victim(true)
  end
  
  def victors
    self.pilots.find_all_by_is_victim(false)
  end
  
  def total_damage
    damage_count = 0
    self.victors.map {|v| damage_count += v.damage}
    damage_count
  end
  
  def manifest_list
    require 'app/models/manifest_item'
    YAML.load( self.manifest ).sort {|x,y| x.to_s <=> y.to_s }
  end
  
  ## active record methods
  # makes sure that a killmail is parsed before attempting to save the kill
  def before_save
    begin
      self.attributes = Kill.parse(self.killmail)
    rescue ArgumentError => exception
      return false
    end
  end
  
  def self.find_recent_kills
  end
  
  def self.find_recent_losses
    
  end
    
  ## Formatting methods
  #
  def to_xml( options = {} )
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:ident])
    xml.instruct! unless options[:skip_instruct]
    xml.kill do
      xml.tag!(:id, self.id)
      xml.tag!(:checksum, self.checksum)
      xml.tag!(:posted, self.posted)
      xml.tag!(:region, self.region)
      self.victim.solar_system.to_xml(:skip_instruct => true, :builder => xml)
      xml.involved_parties do
        self.pilots.each {|v| v.to_xml(:skip_instruct => true, :builder => xml, :location => false)}
      end
      self.manifest_list.each do |category, list|
        xml.tag!(category) do
          list.each do |i| 
            xml.item do
              xml.tag!(:name, i.item_name)
              xml.tag!(:quantity, i.quantity)
            end
          end
        end
      end
    end
  end
  
  ## parsing methods
  # parses a killmail textblock into a hash suited for creating a Kill object
  def self.parse(killmail = nil)
    require 'digest/md5'
    raise ArgumentError, "Killmail is empty.", caller if killmail.nil? or killmail.empty?
    
    # determine start and end points for each block
    involved_parties_start = killmail.index(/^Involved parties:/)
    destroyed_items_start = killmail.index(/^Destroyed items:/)
    dropped_items_start = killmail.index(/^Dropped items:/)
    
    involved_parties_end = destroyed_items_start.nil? ? killmail.length : destroyed_items_start
    destroyed_items_end = dropped_items_start.nil? ? killmail.length : dropped_items_start
    dropped_items_end = killmail.length
    
    raise ArgumentError, "Killmail is malformed.", caller if involved_parties_start.nil?

    parsed = {:posted => nil, :pilots => []}

    # slice the header and parse the posted date
    header = killmail.slice(0, involved_parties_start)
    parsed[:posted] = header.slice(0, 19) # yyyy.mm.dd hh:mm:ss
    
    # check to see if the killmail format is malformed
    raise ArgumentError, "Killmail is malformed.", caller if header =~ /Victim: (.*?)Alliance: (.*)/
    
    # parse victim
    victim = Pilot.new(:is_victim => true)
    victim.name = $1.strip if header =~ /Victim: (.*)/
    victim.corporation_name = $1.strip if header =~ /Corp: (.*)/
    victim.alliance_name = $1.strip if header =~ /Alliance: (.*)/
    victim.faction_name = $1.strip if header =~ /Faction: (.*)/
    victim.ship_name = $1.strip if header =~ /Destroyed: (.*)/
    victim.system_name = $1.strip if header =~ /System: (.*)/
    victim.security_status = $1.strip if header =~ /Security: (.*)/
    victim.damage = $1.strip if header =~ /Damage Taken: (.*)/
    
    parsed[:pilots] << victim
    
    # parse involved parties
    involved_parties = killmail.slice(involved_parties_start + 17, involved_parties_end - involved_parties_start - 17).strip.split(/^(\r\n?)/)
    involved_parties.delete("\r\n")
    
    involved_parties.each do |involved_party|
      pilot = Pilot.new
      pilot.name = $1.strip if involved_party =~ /Name: (.*)/
      pilot.security_status = $1.strip if involved_party =~ /Security: (.*)/
      pilot.corporation_name = $1.strip if involved_party =~ /Corp: (.*)/
      pilot.alliance_name = $1.strip if involved_party =~ /Alliance: (.*)/
      pilot.faction_name = $1.strip if involved_party =~ /Faction: (.*)/
      pilot.ship_name = $1.strip if involved_party =~ /Ship: (.*)/
      pilot.weapon_name = $1.strip if involved_party =~ /Weapon: (.*)/
      pilot.damage = $1.strip if involved_party =~ /Damage Done: (.*)?/

      # strip out 'laid the final blow'
      if pilot.name.include? " (laid the final blow)"
        pilot.laid_final_blow = true
        pilot.name.gsub!(" (laid the final blow)",'')
      end

      parsed[:pilots] << pilot
    end
    
    # parse the manifest of destroyed & dropped items
    manifest = Hash.new
    
    # parse destroyed items
    unless destroyed_items_start.nil?
      manifest[:destroyed_items] = Array.new
      destroyed_items = killmail.slice(destroyed_items_start + 16, destroyed_items_end - destroyed_items_start - 16).strip.split("\r\n")
      destroyed_items.each do |item|
        destroyed_item = ManifestItem.new(item.strip, 1, true)
        
        # strip out quantity
        if destroyed_item.item_name.include?(',')
          destroyed_item.quantity = $1.strip if item =~ /Qty: (\d+)/
          destroyed_item.item_name = destroyed_item.item_name.split(',').first
        end
        
        # strip out the cargo and drone bay
        if destroyed_item.item_name.include?('(')
          storage = $1.strip if item =~ /\((.*)\)/
          destroyed_item.in_cargo = true if storage.eql? 'Cargo'
          destroyed_item.in_dronebay = true if storage.eql? 'Drone Bay'
          destroyed_item.item_name = destroyed_item.item_name.split('(').first.strip
        end

        # associate with an invType item (if possible)
        destroyed_item.lookup!
        manifest[:destroyed_items] << destroyed_item
      end
    end
    
    # parse dropped items
    unless dropped_items_start.nil?
      manifest[:dropped_items] = Array.new
      dropped_items = killmail.slice(dropped_items_start + 14, dropped_items_end - dropped_items_start - 14).strip.split("\r\n")
      dropped_items.each do |item|
        dropped_item = ManifestItem.new(item.strip, 1, false)
        
        # strip out quantity and cargo fittings
        if dropped_item.item_name.include?(',')
          dropped_item.quantity = $1.strip if item =~ /Qty: (\d+)/
          dropped_item.item_name = dropped_item.item_name.split(',').first
        end
        
        # strip out the cargo and drone bay
        if dropped_item.item_name.include?('(')
          storage = $1.strip if item =~ /\((.*)\)/
          dropped_item.in_cargo = true if storage.eql? 'Cargo'
          dropped_item.in_dronebay = true if storage.eql? 'Drone Bay'
          dropped_item.item_name = dropped_item.item_name.split('(').first.strip
        end
        
        dropped_item.lookup!
        manifest[:dropped_items] << dropped_item
      end
    end
    
    # load the manifest into the kill
    parsed[:manifest] = manifest.to_yaml
    
    # load the killmail and create a checksum to validate uniqueness
    parsed[:killmail] = killmail
    parsed[:checksum] = Digest::MD5.hexdigest( killmail )
    
    return parsed
  end
  
  def parse
    Kill.parse( self.killmail )
  end
end

