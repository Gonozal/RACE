class CreateSkillQueues < ActiveRecord::Migration
  def change
    create_table :skill_queues do |t|
      t.integer :character_id
    	t.integer :queue_position
      t.integer :type_id
      t.integer :level
      t.integer :start_sp
      t.integer :end_sp
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
    add_index :skill_queues, :character_id
    add_index :skill_queues, :queue_position
  end
end
