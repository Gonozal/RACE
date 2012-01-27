class CreateContractBids < ActiveRecord::Migration
  def change
    create_table :contract_bids do |t|
      t.integer :contract_id, size: 8
      t.integer :bidder_id, size: 8
      t.datetime :date_bid
      t.decimal :amount, scale: 2, precision: 14
      t.timestamps
    end
    add_index :contract_bids, :contract_id
  end
end
