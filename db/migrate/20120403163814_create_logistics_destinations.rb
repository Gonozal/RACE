class CreateLogisticsDestinations < ActiveRecord::Migration
  def change
    create_table :logistics_destinations do |t|
      t.integer :station_id

      t.timestamps
    end
  end
end
