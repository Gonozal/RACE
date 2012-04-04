class CreateFittings < ActiveRecord::Migration
  def change
    create_table :fittings do |t|
      t.integer :character_id
      t.boolean :corp_approved
      t.boolean :alliance_approved
      t.integer :ship_type_id
      t.text :description

      t.timestamps
    end
  end
end
