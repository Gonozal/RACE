class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :account_id
      t.string :name
      t.integer :api_id
      t.string :v_code
      t.string :corporation_name
      t.integer :corporation_id
      t.integer :skill_in_training
      t.datetime :date_of_birth
      t.string :race
      t.string :blood_line
      t.string :ancestry
      t.string :gender
      t.string :clone_name
      t.integer :clone_skill_points
      t.decimal :balance, scale: 2, precision: 14
      t.integer :intelligence
      t.integer :memory
      t.integer :charisma
      t.integer :perception
      t.integer :willpower
      t.timestamps
    end
    add_index :characters, :account_id
    add_index :characters, :name
    add_index :characters, :corporation_id
  end
end
