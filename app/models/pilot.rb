class Pilot < ActiveRecord::Base
  belongs_to :kill
  belongs_to :solar_system
  belongs_to :alliance
  
  validates_presence_of :name, :corporation_name, :security_status
  validates_presence_of :damage
  
  ## accessors
  #
  def ship_name=( ship_name )
    ship = InvType.find_by_name( ship_name )
    self.ship_id = ship.nil? ? 0 : ship.id
  end
  
  def system_name=( system_name )
    solar_system = SolarSystem.find_by_name( system_name )
    self.solar_system_id = solar_system.nil? ? 0 : solar_system.id
  end
  
  def alliance_name=( alliance_name )
    alliance = Alliance.find_by_name( alliance_name )
    self.alliance_id = alliance.nil? ? 0 : alliance.id
  end
  
  def faction_name=( faction_name )
  end
  
  def alliance_name
    self.alliance.nil? ? 'NONE' : self.alliance.name
  end
  
  def details
    "#{self.name},#{self.corporation_name},#{self.alliance_name}"
  end

  ## shorthand methods
  #
  def ship
    InvType.find( self.ship_id )
  end
  
  ## Formatting methods
  #
  def to_xml( options = {} )
    options[:indent] ||= 2
    options[:location] ||= false
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:ident])
    xml.instruct! unless options[:skip_instruct]
    xml.pilot do
      xml.tag!(:id, self.id)
      xml.tag!(:victim, true) if self.is_victim
      xml.tag!(:finalblow, true) if self.laid_final_blow
      xml.tag!(:name, self.name)
      xml.corporation do 
        xml.tag!(:name, self.corporation_name)
        self.alliance.to_xml(:skip_instruct => true, :builder => xml) unless self.alliance.nil?
      end
      xml.ship do
        xml.tag!(:name, self.ship.name)
        xml.tag!(:weapon, self.weapon_name) unless self.is_victim
      end
      xml.tag!(:security_status, self.security_status) unless self.is_victim
      xml.tag!(:damage, self.damage, :type => self.is_victim ? 'taken' : 'inflicted')
      self.solar_system.to_xml(:skip_instruct => true, :builder => xml) if self.is_victim and options[:location]
    end
  end

end
