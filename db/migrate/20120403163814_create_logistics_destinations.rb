class CreateLogisticsDeliveryLocations < ActiveRecord::Migration
  def change
    create_table :logistics_delivery_locations do |t|
      t.integer :destination_id

      t.timestamps
    end
  end
end
