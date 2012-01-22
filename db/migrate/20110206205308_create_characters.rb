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
      t.timestamps
    end
    add_index :characters, :account_id
    add_index :characters, :name
    add_index :characters, :corporation_id
  end
end
