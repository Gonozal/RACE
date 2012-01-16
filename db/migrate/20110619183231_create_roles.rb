class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :title
      t.references :character
      
      t.timestamps
    end
  end
end
