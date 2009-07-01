class CreateAlliances < ActiveRecord::Migration
  def self.up
    create_table :alliances, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name, :null => false
      t.string :short_name, :null => false
      t.string :eve_id, :null => false
      t.string :icon, :default => '01_01'
      t.string :executor_corp_id
      t.datetime :start_date
      t.timestamps
    end
  end

  def self.down
    drop_table :alliances
  end
end