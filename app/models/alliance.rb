class Alliance < ActiveRecord::Base
  
  ## Formatting methods
  #
  def to_xml( options = {} )
    options[:indent] ||= 2
    options[:vservers] ||= false
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:ident])
    xml.instruct! unless options[:skip_instruct]
    xml.alliance do
      xml.tag!(:id, self.eve_id)
      xml.tag!(:name, self.name)
      xml.tag!(:shortname, self.short_name)
      xml.tag!(:icon, self.icon)
    end
  end
end
