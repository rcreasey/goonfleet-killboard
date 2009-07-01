class CreateKills < ActiveRecord::Migration
  def self.up
    create_table :kills, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.datetime :posted, :default => '0000-00-00 00:00:00'
      t.string :checksum, :null => false
      t.text :killmail, :null => false
      t.text :manifest,
      t.timestamps
    end
    
    add_index :kills, :checksum, :unique => true
  end

  def self.down
    drop_table :kills
  end
end