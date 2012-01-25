class CreateAlliances < ActiveRecord::Migration
  def change
    create_table :alliances do |t|
      t.string :name
      t.string :short_name
      t.integer :executor_corp_id
      t.integer :member_count
      t.datetime :start_date
      t.boolean :disbanded
      t.timestamps
    end
    add_index :executor_corp_id
  end
end
