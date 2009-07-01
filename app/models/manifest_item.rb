class ManifestItem
  
  def initialize( item_name, quantity = 1, is_destroyed = false, in_cargo = false, in_dronebay = false)
    @item_name, @quantity, @is_destroyed, @in_cargo, @in_dronebay = item_name, quantity, is_destroyed, in_cargo, in_dronebay
  end

  attr_accessor :item_id, :item_name, :quantity, :is_destroyed, :in_cargo, :in_dronebay, :power_slot
  
  ## setter methods
  def lookup!
    begin
      @item_id = InvType.find_by_name( item_name ).id
    rescue
      @item_id = 0
    end
  end
  
  ## getter methods
  def item
    InvType.find( @item_id )
  end
  
  def get_power_slot
    query  = "SELECT TRIM(effect.effectName) AS slot "
    query += "FROM invTypes AS type "
    query += "     INNER JOIN dgmTypeEffects AS typeEffect "
    query += "       ON type.typeID = typeEffect.typeID "
    query += "     INNER JOIN dgmEffects AS effect "
    query += "       ON typeEffect.effectID = effect.effectID "
    query += "WHERE effect.effectName IN ('loPower', 'medPower', 'hiPower', 'rigSlot') "
    query += "  AND type.typeName = '#{self.item_name}';"
    
    sql = ActiveRecord::Base.connection()
    value = sql.execute( query )
  end
  
  def fitting
    
  end
  
  ## Formatting methods
  #
  def to_xml( options = {} )
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:ident])
    xml.instruct! unless options[:skip_instruct]
    xml.item do
      xml.tag!(:name, self.item_name)
      xml.tag!(:quantity, self.quantity)
    end
  end
end