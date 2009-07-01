# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080727000610) do

  create_table "alliances", :force => true do |t|
    t.string   "name",                                  :null => false
    t.string   "short_name",                            :null => false
    t.string   "eve_id",                                :null => false
    t.string   "icon",             :default => "01_01"
    t.string   "executor_corp_id"
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kills", :force => true do |t|
    t.datetime "posted"
    t.string   "checksum",                                                       :null => false
    t.text     "killmail",                                                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "manifest"
    t.text     "#<ActiveRecord::ConnectionAdapters::TableDefinition:0x23c15fc>"
  end

  add_index "kills", ["checksum"], :name => "index_kills_on_checksum", :unique => true

  create_table "pilots", :force => true do |t|
    t.integer  "kill_id",                             :null => false
    t.integer  "ship_id",                             :null => false
    t.integer  "solar_system_id"
    t.string   "name",                                :null => false
    t.string   "corporation_name",                    :null => false
    t.string   "alliance_id",                         :null => false
    t.string   "faction_name"
    t.float    "security_status",  :default => 0.0,   :null => false
    t.integer  "damage",                              :null => false
    t.boolean  "is_victim",        :default => false
    t.boolean  "laid_final_blow",  :default => false
    t.string   "weapon_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pilots", ["is_victim"], :name => "index_pilots_on_is_victim"
  add_index "pilots", ["kill_id"], :name => "index_pilots_on_kill_id"
  add_index "pilots", ["ship_id"], :name => "index_pilots_on_ship_id"
  add_index "pilots", ["solar_system_id"], :name => "index_pilots_on_solar_system_id"

end
