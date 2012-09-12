class CreateImplants < ActiveRecord::Migration
  def change
    create_table :implants do |t|
      t.integer :character_id

      t.string :intelligence_name
      t.integer :intelligence_value

      t.string :memory_name
      t.integer :memory_value

      t.string :charisma_name
      t.integer :charisma_value

      t.string :perception_name
      t.integer :perception_value

      t.string :willpower_name
      t.integer :willpower_value

      t.timestamps
    end
  end
end
