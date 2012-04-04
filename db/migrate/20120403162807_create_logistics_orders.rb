class CreateLogisticsOrders < ActiveRecord::Migration
  def change
    create_table :logistics_orders do |t|
      t.integer :creator_id
      t.integer :postman_id
      t.boolean :submitted, default: false
      t.string :status
      t.integer :destination_id

      t.timestamps
    end
  end
end
