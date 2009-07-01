class SolarSystem < ActiveRecord::Base
  set_table_name "mapSolarSystems"
  set_primary_key "solarSystemID"
  
  ## shorthand methods
  #
  def name
    self.solarSystemName
  end

  def region
    Region.find( self.regionID )
  end
  
  ## activerecord methods
  def self.find_by_name( name )
    SolarSystem.find(:first, :conditions => ['solarSystemName = ?', name])
  end
  
  ## Formatting methods
  #
  def to_xml( options = {} )
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:ident])
    xml.instruct! unless options[:skip_instruct]
    xml.system do
      xml.tag!(:id, self.id)
      xml.tag!(:name, self.name)
      xml.tag!(:security, sprintf('%.2f',self.security))
      self.region.to_xml(:skip_instruct => true, :builder => xml)
    end
  end
end
