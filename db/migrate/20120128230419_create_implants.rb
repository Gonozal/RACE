class CreateImplants < ActiveRecord::Migration
  def change
    create_table :implants do |t|
      t.integer :character_id
      t.string :augmentator_name
      t.integer :augmentator_value

      t.timestamps
    end
  end
end
