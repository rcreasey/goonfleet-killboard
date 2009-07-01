class InvType < ActiveRecord::Base
  set_table_name "invTypes"
  set_primary_key "typeID"
  
  ## shorthand methods
  #
  def id
    self.typeID
  end
  
  def name
    self.typeName
  end
  
  def icon
    # select icon from eveGraphics where id = self.graphicID
  end
  
  ## activerecord methods
  #
  def self.find_by_name( name )
    InvType.find(:first, :conditions => ['typeName = ?', name])
  end
end
