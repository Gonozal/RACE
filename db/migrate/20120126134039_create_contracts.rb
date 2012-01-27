class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :issuer_id, size: 8
      t.integer :issuer_corp_id, size: 8
      t.integer :assignee_id, size: 8
      t.integer :acceptor_id, size: 8
      t.integer :start_station_id
      t.integer :end_station_id
      t.string :contract_type
      t.string :status
      t.string :title
      t.boolean :for_corp
      t.string :availability
      t.datetime :date_issued
      t.datetime :date_expired
      t.datetime :date_accepted
      t.integer :num_days
      t.datetime :date_completed
      t.decimal :price, scale: 2, precision: 14
      t.decimal :reward, scale: 2, precision: 14
      t.decimal :collateral, scale: 2, precision: 14
      t.decimal :price, scale: 2, precision: 14
      t.float :volume
    end
    add_index :contracts, :issuer_id
    add_index :contracts, :assignee_id
    add_index :contracts, :acceptor_id
    add_index :contracts, :start_station_id
    add_index :contracts, :end_station_id
    add_index :contracts, :status
  end
end
