class CreateMarketOrders < ActiveRecord::Migration
  def change
    create_table :market_orders do |t|
      t.integer :character_id
      t.integer :corporation_id
      t.integer :account_key
      t.integer :order_id
      t.integer :char_id
      t.integer :sation_id
      t.integer :vol_entered
      t.integer :vol_remaining
      t.integer :min_volume
      t.integer :order_state
      t.integer :type_id
      t.integer :range
      t.integer :duration
      t.decimal :escrow, scale: 2, precision: 14
      t.decimal :price, scale: 2, precision: 14
      t.boolean :bid
      t.integer :issued

      t.timestamps
    end
  end
end
