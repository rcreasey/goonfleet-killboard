class CreatePilots < ActiveRecord::Migration
  def self.up
    create_table :pilots, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :kill_id, :null => false
      t.integer :ship_id, :null => false
      t.integer :solar_system_id
      t.string :name, :null => false
      t.string :corporation_name, :null => false
      t.string :alliance_id, :null => false
      t.string :faction_name
      t.float :security_status, :null => false, :default => 0
      t.integer :damage, :null => false
      t.boolean :is_victim, :default => false
      t.boolean :laid_final_blow, :default => false
      t.string :weapon_name
      t.timestamps
    end
    
    add_index :pilots, :kill_id
    add_index :pilots, :ship_id
    add_index :pilots, :solar_system_id
    add_index :pilots, :is_victim
  end

  def self.down
    drop_table :pilots
  end
end