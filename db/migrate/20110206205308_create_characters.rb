class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :account_id
      t.string :name
      t.integer :user_id
      t.string :api_key
      t.integer :character_id
      t.string :corporation_name
      t.integer :corporation_id
      t.timestamps
    end
    add_index :characters, :account_id
    add_index :characters, :name
    add_index :characters, :corporation_id
  end
end
