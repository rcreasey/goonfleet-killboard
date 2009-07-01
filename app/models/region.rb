class Region < ActiveRecord::Base
  set_table_name "mapRegions"
  set_primary_key "regionID"
  
  has_many :solar_systems
  
  ## shorthand methods
  #
  def name
    self.regionName
  end
  
  ## Formatting methods
  #
  def to_xml( options = {} )
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:ident])
    xml.instruct! unless options[:skip_instruct]
    xml.region do
      xml.tag!(:id, self.id)
      xml.tag!(:name, self.name)
    end
  end
end
