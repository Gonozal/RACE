class CreateEveRoles < ActiveRecord::Migration
  def change
    create_table :eve_roles do |t|
      t.integer :character_id
      t.integer :role_id
      t.string :role_name
      t.string :role_type

      t.timestamps
    end
  end
end
