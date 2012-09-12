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

ActiveRecord::Schema.define(:version => 20120403163814) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "main_character_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "accounts", ["confirmation_token"], :name => "index_accounts_on_confirmation_token", :unique => true
  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["main_character_id"], :name => "index_accounts_on_main_character_id"
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true
  add_index "accounts", ["unlock_token"], :name => "index_accounts_on_unlock_token", :unique => true

  create_table "alliances", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "executor_corp_id"
    t.integer  "member_count"
    t.datetime "start_date"
    t.boolean  "disbanded"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "alliances", ["executor_corp_id"], :name => "index_alliances_on_executor_corp_id"

  create_table "api_keys", :force => true do |t|
    t.integer  "api_id"
    t.string   "v_code"
    t.string   "registration_token"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.decimal  "balance",                        :precision => 14, :scale => 2
    t.integer  "account_id"
    t.integer  "api_key_id"
    t.integer  "corporation_id"
    t.string   "gender"
    t.string   "race"
    t.string   "blood_line"
    t.string   "ancestry"
    t.datetime "date_of_birth"
    t.integer  "skill_in_training"
    t.integer  "clone_skill_points"
    t.string   "clone_name"
    t.integer  "skill_points"
    t.integer  "intelligence"
    t.integer  "memory"
    t.integer  "charisma"
    t.integer  "perception"
    t.integer  "willpower"
    t.datetime "last_character_sheet_update"
    t.boolean  "auto_character_sheet_update",                                   :default => true
    t.datetime "last_skill_update"
    t.boolean  "auto_skill_update",                                             :default => true
    t.datetime "last_skill_queue_update"
    t.boolean  "auto_skill_queue_update",                                       :default => true
    t.datetime "last_asset_update"
    t.boolean  "auto_asset_update",                                             :default => true
    t.datetime "last_contract_update"
    t.boolean  "auto_contract_update",                                          :default => true
    t.datetime "last_mail_update"
    t.boolean  "auto_mail_update",                                              :default => true
    t.datetime "last_notification_update"
    t.boolean  "auto_notification_update",                                      :default => true
    t.datetime "last_market_order_update"
    t.boolean  "auto_market_order_update",                                      :default => true
    t.datetime "last_wallet_journal_update"
    t.boolean  "auto_wallet_journal_update",                                    :default => true
    t.datetime "last_wallet_transaction_update"
    t.boolean  "auto_wallet_transaction_update",                                :default => true
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
  end

  add_index "characters", ["account_id"], :name => "index_characters_on_account_id"
  add_index "characters", ["corporation_id"], :name => "index_characters_on_corporation_id"
  add_index "characters", ["name"], :name => "index_characters_on_name"

  create_table "characters_eve_notifications", :id => false, :force => true do |t|
    t.integer "character_id"
    t.integer "eve_notification_id"
  end

  add_index "characters_eve_notifications", ["character_id"], :name => "index_characters_eve_notifications_on_character_id"
  add_index "characters_eve_notifications", ["eve_notification_id"], :name => "index_characters_eve_notifications_on_eve_notification_id"

  create_table "characters_roles", :force => true do |t|
    t.integer  "character_id"
    t.integer  "role_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "contract_bids", :force => true do |t|
    t.integer  "contract_id"
    t.integer  "bidder_id"
    t.datetime "date_bid"
    t.decimal  "amount",      :precision => 14, :scale => 2
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "contract_bids", ["contract_id"], :name => "index_contract_bids_on_contract_id"

  create_table "contract_items", :force => true do |t|
    t.integer  "contract_id"
    t.integer  "type_id"
    t.integer  "quantity"
    t.integer  "raw_quantity"
    t.boolean  "singleton"
    t.boolean  "included"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "contract_items", ["type_id"], :name => "index_contract_items_on_type_id"

  create_table "contracts", :force => true do |t|
    t.integer  "issuer_id"
    t.integer  "issuer_corp_id"
    t.integer  "assignee_id"
    t.integer  "acceptor_id"
    t.integer  "start_station_id"
    t.integer  "end_station_id"
    t.string   "contract_type"
    t.string   "status"
    t.string   "title"
    t.boolean  "for_corp"
    t.string   "availability"
    t.datetime "date_issued"
    t.datetime "date_expired"
    t.datetime "date_accepted"
    t.integer  "num_days"
    t.datetime "date_completed"
    t.decimal  "price",            :precision => 14, :scale => 2
    t.decimal  "reward",           :precision => 14, :scale => 2
    t.decimal  "collateral",       :precision => 14, :scale => 2
    t.float    "volume"
  end

  add_index "contracts", ["acceptor_id"], :name => "index_contracts_on_acceptor_id"
  add_index "contracts", ["assignee_id"], :name => "index_contracts_on_assignee_id"
  add_index "contracts", ["end_station_id"], :name => "index_contracts_on_end_station_id"
  add_index "contracts", ["issuer_id"], :name => "index_contracts_on_issuer_id"
  add_index "contracts", ["start_station_id"], :name => "index_contracts_on_start_station_id"
  add_index "contracts", ["status"], :name => "index_contracts_on_status"

  create_table "corporations", :force => true do |t|
    t.string   "name"
    t.string   "ticker"
    t.string   "ceo_name"
    t.integer  "ceo_character_id"
    t.integer  "api_key_id"
    t.text     "description"
    t.string   "url"
    t.integer  "alliance_id"
    t.string   "alliance_name"
    t.string   "tax_rate"
    t.integer  "member_count"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "corporations", ["alliance_id"], :name => "index_corporations_on_alliance_id"
  add_index "corporations", ["name"], :name => "index_corporations_on_name"

  create_table "eve_assets", :force => true do |t|
    t.integer  "character_id"
    t.integer  "corporation_id"
    t.integer  "item_id"
    t.integer  "location_id"
    t.integer  "type_id"
    t.integer  "quantity"
    t.integer  "flag"
    t.boolean  "singleton"
    t.integer  "raw_quantity"
    t.string   "ancestry"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "eve_assets", ["ancestry"], :name => "index_eve_assets_on_ancestry"
  add_index "eve_assets", ["character_id"], :name => "index_eve_assets_on_character_id"
  add_index "eve_assets", ["corporation_id"], :name => "index_eve_assets_on_corporation_id"
  add_index "eve_assets", ["type_id"], :name => "index_eve_assets_on_type_id"

  create_table "eve_mails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_date"
    t.string   "title"
    t.text     "body"
    t.integer  "to_corp_or_alliance_id"
    t.string   "to_character_ids"
    t.string   "to_list_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "eve_mails", ["sender_id"], :name => "index_eve_mails_on_sender_id"
  add_index "eve_mails", ["sent_date"], :name => "index_eve_mails_on_sent_date"
  add_index "eve_mails", ["to_corp_or_alliance_id"], :name => "index_eve_mails_on_to_corp_or_alliance_id"

  create_table "eve_notifications", :force => true do |t|
    t.integer  "type_id"
    t.integer  "sender_id"
    t.datetime "sent_date"
    t.boolean  "read"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "eve_notifications", ["read"], :name => "index_eve_notifications_on_read"
  add_index "eve_notifications", ["sender_id"], :name => "index_eve_notifications_on_sender_id"
  add_index "eve_notifications", ["type_id"], :name => "index_eve_notifications_on_type_id"

  create_table "eve_roles", :force => true do |t|
    t.integer  "character_id"
    t.integer  "role_id"
    t.string   "role_name"
    t.string   "role_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "eveapi_cache", :force => true do |t|
    t.string   "request_hash"
    t.text     "xml"
    t.datetime "cached_until"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "eveapi_cache", ["request_hash"], :name => "index_eveapi_cache_on_request_hash"

  create_table "fitting_modules", :force => true do |t|
    t.integer  "fitting_id"
    t.integer  "slot"
    t.string   "type"
    t.integer  "type_id"
    t.integer  "charge_type_id"
    t.integer  "amount"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "fittings", :force => true do |t|
    t.integer  "character_id"
    t.boolean  "corp_approved"
    t.boolean  "alliance_approved"
    t.integer  "ship_type_id"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "implants", :force => true do |t|
    t.integer  "character_id"
    t.string   "intelligence_name"
    t.integer  "intelligence_value"
    t.string   "memory_name"
    t.integer  "memory_value"
    t.string   "charisma_name"
    t.integer  "charisma_value"
    t.string   "perception_name"
    t.integer  "perception_value"
    t.string   "willpower_name"
    t.integer  "willpower_value"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "industry_jobs", :force => true do |t|
    t.integer  "job_id"
    t.integer  "corporation_id"
    t.integer  "assembly_line_id"
    t.integer  "container_id"
    t.integer  "installed_item_id"
    t.integer  "installed_item_location_id"
    t.integer  "installed_item_quantity"
    t.integer  "installed_item_productivity_level"
    t.integer  "installed_item_material_level"
    t.integer  "installed_item_licensed_production_runs_remaining"
    t.integer  "output_location_id"
    t.integer  "installer_id"
    t.integer  "runs"
    t.integer  "licensed_production_runs"
    t.integer  "installed_in_solar_system_id"
    t.integer  "container_location_id"
    t.float    "material_multiplier"
    t.float    "char_material_multiplier"
    t.float    "time_multiplier"
    t.float    "char_time_multiplier"
    t.integer  "installed_item_type_id"
    t.integer  "output_type_id"
    t.integer  "container_type_id"
    t.integer  "installed_item_copy"
    t.integer  "completed"
    t.integer  "completed_succesfully"
    t.integer  "installed_item_flag"
    t.integer  "output_flag"
    t.integer  "activity_id"
    t.integer  "completed_status"
    t.datetime "install_time"
    t.datetime "begin_production_time"
    t.datetime "end_production_time"
    t.datetime "pause_production_time"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "industry_jobs", ["container_id"], :name => "index_industry_jobs_on_container_id"
  add_index "industry_jobs", ["installed_item_location_id"], :name => "index_industry_jobs_on_installed_item_location_id"
  add_index "industry_jobs", ["installer_id"], :name => "index_industry_jobs_on_installer_id"

  create_table "logistics_destinations", :force => true do |t|
    t.integer  "station_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "logistics_order_items", :force => true do |t|
    t.integer  "logistics_order_id"
    t.integer  "type_id"
    t.integer  "amount",             :default => 1
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "logistics_orders", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "postman_id"
    t.boolean  "submitted",      :default => false
    t.string   "status"
    t.integer  "destination_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "mailerships", :force => true do |t|
    t.integer  "character_id"
    t.integer  "mailing_list_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "mailerships", ["character_id"], :name => "index_mailerships_on_character_id"
  add_index "mailerships", ["mailing_list_id"], :name => "index_mailerships_on_mailing_list_id"

  create_table "mailing_lists", :force => true do |t|
    t.string   "display_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "market_orders", :force => true do |t|
    t.integer  "character_id"
    t.integer  "corporation_id"
    t.integer  "account_key"
    t.integer  "order_id"
    t.integer  "char_id"
    t.integer  "sation_id"
    t.integer  "vol_entered"
    t.integer  "vol_remaining"
    t.integer  "min_volume"
    t.integer  "order_state"
    t.integer  "type_id"
    t.integer  "range"
    t.integer  "duration"
    t.decimal  "escrow",         :precision => 14, :scale => 2
    t.decimal  "price",          :precision => 14, :scale => 2
    t.boolean  "bid"
    t.integer  "issued"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "market_prices", :force => true do |t|
    t.integer  "type_id"
    t.integer  "character_id",                                :default => 0
    t.decimal  "price",        :precision => 14, :scale => 2
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.integer  "character_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "skill_queues", :force => true do |t|
    t.integer  "character_id"
    t.integer  "queue_position"
    t.integer  "type_id"
    t.integer  "level"
    t.integer  "start_sp"
    t.integer  "end_sp"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "skill_queues", ["character_id"], :name => "index_skill_queues_on_character_id"
  add_index "skill_queues", ["queue_position"], :name => "index_skill_queues_on_queue_position"

  create_table "skills", :force => true do |t|
    t.integer  "type_id"
    t.integer  "character_id"
    t.string   "name"
    t.string   "group_name"
    t.integer  "group_id"
    t.integer  "level"
    t.integer  "skill_points"
    t.integer  "skill_time_constant"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "skills", ["character_id"], :name => "index_skills_on_character_id"
  add_index "skills", ["type_id"], :name => "index_skills_on_type_id"
  add_index "skills", ["updated_at"], :name => "index_skills_on_updated_at"

  create_table "so_awesomes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "wallet_journals", :force => true do |t|
    t.integer  "character_id"
    t.integer  "corporation_id"
    t.integer  "account_key"
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
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "wallet_journals", ["account_key"], :name => "index_wallet_journals_on_account_key"
  add_index "wallet_journals", ["character_id"], :name => "index_wallet_journals_on_character_id"
  add_index "wallet_journals", ["corporation_id"], :name => "index_wallet_journals_on_corporation_id"
  add_index "wallet_journals", ["date"], :name => "index_wallet_journals_on_date"
  add_index "wallet_journals", ["ref_id"], :name => "index_wallet_journals_on_ref_id"
  add_index "wallet_journals", ["ref_type_id"], :name => "index_wallet_journals_on_ref_type_id"
  add_index "wallet_journals", ["tax_receiver_id"], :name => "index_wallet_journals_on_tax_receiver_id"

  create_table "wallet_transactions", :force => true do |t|
    t.integer  "character_id"
    t.integer  "corporation_id"
    t.integer  "account_key"
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
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  add_index "wallet_transactions", ["account_key"], :name => "index_wallet_transactions_on_account_key"
  add_index "wallet_transactions", ["character_id"], :name => "index_wallet_transactions_on_character_id"
  add_index "wallet_transactions", ["corporation_id"], :name => "index_wallet_transactions_on_corporation_id"
  add_index "wallet_transactions", ["station_id"], :name => "index_wallet_transactions_on_station_id"
  add_index "wallet_transactions", ["transaction_for"], :name => "index_wallet_transactions_on_transaction_for"
  add_index "wallet_transactions", ["type_id"], :name => "index_wallet_transactions_on_type_id"

end
