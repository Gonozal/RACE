class CreateEveAssets < ActiveRecord::Migration
  def change
    create_table :eve_assets do |t|
      t.integer :character_id
      t.integer :corporation_id
      t.integer :item_id, size: 8
      t.integer :location_id, size: 8
      t.integer :type_id
      t.integer :quantity, default: 0
      t.integer :flag, default: 0
      t.boolean :singleton, default: false
      t.integer :raw_quantity
      t.string :ancestry
      t.timestamps
    end
    add_index :eve_assets, :character_id
    add_index :eve_assets, :corporation_id
    add_index :eve_assets, :ancestry
    add_index :eve_assets, :type_id
  end
end
