# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110702234822) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "password_hash"
    t.integer  "main_character_id"
    t.string   "email"
    t.string   "forgot_password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["name"], :name => "index_accounts_on_name"

  create_table "characters", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.integer  "user_id"
    t.string   "api_key"
    t.integer  "character_id"
    t.string   "corporation_name"
    t.integer  "corporation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["account_id"], :name => "index_characters_on_account_id"
  add_index "characters", ["corporation_id"], :name => "index_characters_on_corporation_id"
  add_index "characters", ["name"], :name => "index_characters_on_name"

  create_table "characters_roles", :force => true do |t|
    t.integer  "character_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corporations", :force => true do |t|
    t.string   "name"
    t.integer  "corporation_id"
    t.string   "ticker"
    t.string   "ceo_name"
    t.integer  "ceo_character_id"
    t.text     "description"
    t.string   "url"
    t.integer  "alliance_id"
    t.string   "alliance_name"
    t.string   "tax_rate"
    t.integer  "member_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corporations", ["alliance_id"], :name => "index_corporations_on_alliance_id"
  add_index "corporations", ["corporation_id"], :name => "index_corporations_on_corporation_id"
  add_index "corporations", ["name"], :name => "index_corporations_on_name"

  create_table "eveapi_cache", :force => true do |t|
    t.string   "request_hash"
    t.text     "xml"
    t.datetime "cached_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eveapi_cache", ["request_hash"], :name => "index_eveapi_cache_on_request_hash"

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
