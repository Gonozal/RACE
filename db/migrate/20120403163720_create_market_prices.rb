class CreateMarketPrices < ActiveRecord::Migration
  def change
    create_table :market_prices do |t|
      t.integer :type_id
      t.integer :character_id, default: 0
      t.decimal :price, scale: 2, precision: 14

      t.timestamps
    end
  end
end
