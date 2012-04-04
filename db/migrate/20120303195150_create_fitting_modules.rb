class CreateFittingModules < ActiveRecord::Migration
  def change
    create_table :fitting_modules do |t|
      t.integer :fitting_id
      t.integer :slot # 1-8
      t.string :type # high, med, low, rig, sub, drone, cargo
      t.integer :type_id
      t.integer :charge_type_id
      t.integer :amount

      t.timestamps
    end
  end
end
