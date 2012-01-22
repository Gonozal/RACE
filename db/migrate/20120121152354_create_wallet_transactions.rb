class CreateWalletTransactions < ActiveRecord::Migration
  def change
    create_table :wallet_transactions do |t|
      t.integer :character_id
      t.integer :corporation_id
      t.integer :transaction_time
      t.integer :transaction_id
      t.integer :quantity
      t.string :type_name
      t.integer :type_id
      t.decimal :price, scale: 2, precision: 14
      t.integer :client_id
      t.string :client_name
      t.integer :station_id
      t.integer :station_name
      t.string :transaction_type
      t.string :transaction_for
      t.integer :journal_transaction_id, limit: 8
      t.integer :account_key
      t.timestamps
    end
    add_index :wallet_transactions, :transaction_time
    add_index :wallet_transactions, :type_id
    add_index :wallet_transactions, :station_id
    add_index :wallet_transactions, :transaction_for
    add_index :wallet_transactions, [:character_id, :station_id]
    add_index :wallet_transactions, [:corporation_id, :station_id]
    add_index :wallet_transactions, [:corporation_id, :account_key]
  end
end
