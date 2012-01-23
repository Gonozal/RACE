class CreateWalletJournals < ActiveRecord::Migration
  def change
    create_table :wallet_journals do |t|
      t.integer :character_id
      t.integer :corporation_id
      t.integer :account_key
      t.integer :date
      t.integer :ref_id, :limit => 8
      t.integer :ref_type_id
      t.string :ownerName1
      t.integer :ownerID1
      t.string :ownerName2
      t.integer :ownerID2
      t.string :argName1
      t.integer :argID1
      t.decimal :amount, scale: 2, precision: 14
      t.decimal :balance, scale: 2, precision: 14
      t.string :reason
      t.integer :tax_receiver_id
      t.decimal :tax_amount, scale: 2, precision: 14
      t.timestamps
    end
    add_index :wallet_journals, :ref_type_id
    add_index :wallet_journals, :ref_id
    add_index :wallet_journals, :character_id
    add_index :wallet_journals, :corporation_id
    add_index :wallet_journals, :account_key
    add_index :wallet_journals, :date
    add_index :wallet_journals, :tax_receiver_id
  end
end
