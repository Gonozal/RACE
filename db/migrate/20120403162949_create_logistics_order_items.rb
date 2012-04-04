class CreateLogisticsOrderItems < ActiveRecord::Migration
  def change
    create_table :logistics_order_items do |t|
      t.integer :logistics_order_id
      t.integer :type_id
      t.integer :amount, default: 1

      t.timestamps
    end
  end
end
