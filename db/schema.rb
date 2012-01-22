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

ActiveRecord::Schema.define(:version => 20120122152443) do

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
    t.integer  "api_id"
    t.string   "v_code"
    t.string   "corporation_name"
    t.integer  "corporation_id"
    t.integer  "skill_in_training"
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
    t.integer  "type_id"
    t.integer  "character_id"
    t.string   "name"
    t.string   "group_name"
    t.integer  "group_id"
    t.integer  "level"
    t.integer  "skill_points"
    t.integer  "skill_time_constant"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["character_id"], :name => "index_skills_on_character_id"
  add_index "skills", ["type_id"], :name => "index_skills_on_type_id"
  add_index "skills", ["updated_at"], :name => "index_skills_on_updated_at"

  create_table "wallet_journals", :force => true do |t|
    t.integer  "character_id"
    t.integer  "corporation_id"
    t.integer  "date"
    t.integer  "ref_id",          :limit => 8
    t.integer  "ref_type_id"
    t.string   "ownerName1"
    t.integer  "ownerID1"
    t.string   "ownerName2"
    t.integer  "ownerID2"
    t.string   "argName1"
    t.integer  "argID1"
    t.decimal  "amount",                       :precision => 14, :scale => 2
    t.decimal  "balance",                      :precision => 14, :scale => 2
    t.string   "reason"
    t.integer  "tax_receiver_id"
    t.decimal  "tax_amount",                   :precision => 14, :scale => 2
    t.integer  "account_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallet_journals", ["character_id", "ref_id"], :name => "index_wallet_journals_on_character_id_and_ref_id"
  add_index "wallet_journals", ["corporation_id", "account_key"], :name => "index_wallet_journals_on_corporation_id_and_account_key"
  add_index "wallet_journals", ["corporation_id", "ref_id"], :name => "index_wallet_journals_on_corporation_id_and_ref_id"
  add_index "wallet_journals", ["date"], :name => "index_wallet_journals_on_date"
  add_index "wallet_journals", ["ref_type_id"], :name => "index_wallet_journals_on_ref_type_id"
  add_index "wallet_journals", ["tax_receiver_id"], :name => "index_wallet_journals_on_tax_receiver_id"

  create_table "wallet_transactions", :force => true do |t|
    t.integer  "character_id"
    t.integer  "corporation_id"
    t.integer  "transaction_time"
    t.integer  "transaction_id"
    t.integer  "quantity"
    t.string   "type_name"
    t.integer  "type_id"
    t.decimal  "price",                               :precision => 14, :scale => 2
    t.integer  "client_id"
    t.string   "client_name"
    t.integer  "station_id"
    t.integer  "station_name"
    t.string   "transaction_type"
    t.string   "transaction_for"
    t.integer  "journal_transaction_id", :limit => 8
    t.integer  "account_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallet_transactions", ["character_id", "station_id"], :name => "index_wallet_transactions_on_character_id_and_station_id"
  add_index "wallet_transactions", ["corporation_id", "account_key"], :name => "index_wallet_transactions_on_corporation_id_and_account_key"
  add_index "wallet_transactions", ["corporation_id", "station_id"], :name => "index_wallet_transactions_on_corporation_id_and_station_id"
  add_index "wallet_transactions", ["station_id"], :name => "index_wallet_transactions_on_station_id"
  add_index "wallet_transactions", ["transaction_for"], :name => "index_wallet_transactions_on_transaction_for"
  add_index "wallet_transactions", ["transaction_time"], :name => "index_wallet_transactions_on_transaction_time"
  add_index "wallet_transactions", ["type_id"], :name => "index_wallet_transactions_on_type_id"

end
