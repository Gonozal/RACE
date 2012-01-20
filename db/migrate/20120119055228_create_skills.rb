class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :type_id
      t.integer :character_id
      t.string :name
      t.string :group_name
      t.integer :group_id
      t.integer :level
      t.integer :skill_points
      t.integer :skill_time_constant

      t.timestamps
    end
    add_index :updated_at, :character_id, :type_id
  end
end
