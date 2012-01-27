class CreateIndustryJobs < ActiveRecord::Migration
  def change
    create_table :industry_jobs do |t|
    	t.integer :assembly_line_id
      t.integer :container_id
      t.integer :installed_item_id, size: 8
      t.integer :installed_item_location_id
      t.integer :installed_item_quantity
      t.integer :installed_item_productivity_level
      t.integer :installed_item_material_level
      t.integer :installed_item_licensed_production_runs_remaining
      t.integer :output_location_id
      t.integer :installer_id
      t.integer :runs
      t.integer :licensed_production_runs
      t.integer :installed_in_solar_system_id
      t.integer :container_location_id
      t.float :material_multiplier
      t.float :char_material_multiplier
      t.float :time_multiplier
      t.float :char_time_multiplier
      t.integer :installed_item_type_id
      t.integer :output_type_id
      t.integer :container_type_id
      t.integer :installed_item_copy
      t.integer :completed
      t.integer :completed_succesfully
      t.integer :installed_item_flag
      t.integer :output_flag
      t.integer :activity_id
      t.integer :completed_status
      t.datetime :install_time
      t.datetime :begin_production_time
      t.datetime :end_production_time
      t.datetime :pause_production_time
      t.timestamps
    end
  end
end
