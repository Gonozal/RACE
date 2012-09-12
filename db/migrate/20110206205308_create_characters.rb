class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.decimal :balance, scale: 2, precision: 14

      # references
      t.integer :account_id
      t.integer :api_key_id
      t.integer :corporation_id

      # Race, bloodline, gender etc.
      t.string :gender
      t.string :race
      t.string :blood_line
      t.string :ancestry
      t.datetime :date_of_birth

      # Skill related
      t.integer :skill_in_training
      t.integer :clone_skill_points
      t.string :clone_name
      t.integer :skill_points

      # Attributes
      t.integer :intelligence
      t.integer :memory
      t.integer :charisma
      t.integer :perception
      t.integer :willpower

      # Update Timestamps & Settings
      t.datetime :last_character_sheet_update
      t.boolean :auto_character_sheet_update, default: true

      t.datetime :last_skill_queue_update
      t.boolean :auto_skill_queue_update, default: true

      t.datetime :last_asset_update
      t.boolean :auto_asset_update, default: true

      t.datetime :last_contract_update
      t.boolean :auto_contract_update, default: true

      t.datetime :last_mail_update
      t.boolean :auto_mail_update, default: true

      t.datetime :last_notification_update
      t.boolean :auto_notification_update, default: true

      t.datetime :last_market_order_update
      t.boolean :auto_market_order_update, default: true

      t.datetime :last_wallet_journal_update
      t.boolean :auto_wallet_journal_update, default: true

      t.datetime :last_wallet_transaction_update
      t.boolean :auto_wallet_transaction_update, default: true


      t.timestamps
    end
    add_index :characters, :account_id
    add_index :characters, :name
    add_index :characters, :corporation_id
  end
end
