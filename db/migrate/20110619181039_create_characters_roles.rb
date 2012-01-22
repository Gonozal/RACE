class CreateCharactersRoles < ActiveRecord::Migration
  def change
    create_table :characters_roles do |t|
      t.integer :character_id
      t.integer :role_id
      t.timestamps
    end
  end
end
