class CreateCorporations < ActiveRecord::Migration
  def change
    create_table :corporations do |t|
      t.string :name
      t.string :ticker
      t.string :ceo_name
      t.integer :ceo_character_id
      t.text :description
      t.string :url
      t.integer :alliance_id
      t.string :alliance_name
      t.string :tax_rate
      t.integer :member_count
      t.timestamps
    end
    add_index :corporations, :name
    add_index :corporations, :alliance_id
  end
end
