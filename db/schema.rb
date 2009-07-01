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

  create_table "invGroups", :primary_key => "groupID", :force => true do |t|
    t.integer "categoryID",           :limit => 1
    t.string  "groupName",            :limit => 100
    t.string  "description",          :limit => 3000
    t.integer "graphicID",            :limit => 2
    t.boolean "useBasePrice"
    t.boolean "allowManufacture"
    t.boolean "allowRecycler"
    t.boolean "anchored"
    t.boolean "anchorable"
    t.boolean "fittableNonSingleton"
    t.boolean "published"
  end

  add_index "invGroups", ["categoryID"], :name => "invGroups_IX_category"
  add_index "invGroups", ["graphicID"], :name => "graphicID"

  create_table "invTypes", :primary_key => "typeID", :force => true do |t|
    t.integer "groupID",             :limit => 2
    t.string  "typeName",            :limit => 100
    t.string  "description",         :limit => 3000
    t.integer "graphicID",           :limit => 2
    t.float   "radius"
    t.float   "mass"
    t.float   "volume"
    t.float   "capacity"
    t.integer "portionSize"
    t.integer "raceID",              :limit => 1
    t.float   "basePrice"
    t.boolean "published"
    t.integer "marketGroupID",       :limit => 2
    t.float   "chanceOfDuplicating"
  end

  add_index "invTypes", ["graphicID"], :name => "graphicID"
  add_index "invTypes", ["groupID"], :name => "invTypes_IX_Group"
  add_index "invTypes", ["marketGroupID"], :name => "marketGroupID"
  add_index "invTypes", ["raceID"], :name => "raceID"

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

  create_table "mapConstellations", :primary_key => "constellationID", :force => true do |t|
    t.integer "regionID"
    t.string  "constellationName", :limit => 100
    t.float   "x"
    t.float   "y"
    t.float   "z"
    t.float   "xMin"
    t.float   "xMax"
    t.float   "yMin"
    t.float   "yMax"
    t.float   "zMin"
    t.float   "zMax"
    t.integer "factionID"
    t.float   "radius"
  end

  add_index "mapConstellations", ["constellationID", "regionID"], :name => "constellationID", :unique => true
  add_index "mapConstellations", ["factionID"], :name => "factionID"
  add_index "mapConstellations", ["regionID"], :name => "mapConstellations_IX_region"

  create_table "mapRegions", :primary_key => "regionID", :force => true do |t|
    t.string  "regionName", :limit => 100
    t.float   "x"
    t.float   "y"
    t.float   "z"
    t.float   "xMin"
    t.float   "xMax"
    t.float   "yMin"
    t.float   "yMax"
    t.float   "zMin"
    t.float   "zMax"
    t.integer "factionID"
    t.float   "radius"
  end

  add_index "mapRegions", ["factionID"], :name => "factionID"

  create_table "mapSolarSystems", :primary_key => "solarSystemID", :force => true do |t|
    t.integer "regionID"
    t.integer "constellationID"
    t.string  "solarSystemName", :limit => 100
    t.float   "x"
    t.float   "y"
    t.float   "z"
    t.float   "xMin"
    t.float   "xMax"
    t.float   "yMin"
    t.float   "yMax"
    t.float   "zMin"
    t.float   "zMax"
    t.float   "luminosity"
    t.boolean "border"
    t.boolean "fringe"
    t.boolean "corridor"
    t.boolean "hub"
    t.boolean "international"
    t.boolean "regional"
    t.boolean "constellation"
    t.float   "security"
    t.integer "factionID"
    t.float   "radius"
    t.integer "sunTypeID",       :limit => 2
    t.string  "securityClass",   :limit => 2
  end

  add_index "mapSolarSystems", ["constellationID"], :name => "mapSolarSystems_IX_constellation"
  add_index "mapSolarSystems", ["factionID"], :name => "factionID"
  add_index "mapSolarSystems", ["regionID"], :name => "mapSolarSystems_IX_region"
  add_index "mapSolarSystems", ["security"], :name => "mapSolarSystems_IX_security"
  add_index "mapSolarSystems", ["solarSystemID", "constellationID", "regionID"], :name => "solarSystemID", :unique => true
  add_index "mapSolarSystems", ["sunTypeID"], :name => "sunTypeID"

  create_table "mapUniverse", :primary_key => "universeID", :force => true do |t|
    t.string "universeName", :limit => 100
    t.float  "x"
    t.float  "y"
    t.float  "z"
    t.float  "xMin"
    t.float  "xMax"
    t.float  "yMin"
    t.float  "yMax"
    t.float  "zMin"
    t.float  "zMax"
    t.float  "radius"
  end

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
