class CreateContractItems < ActiveRecord::Migration
  def change
    create_table :contract_items do |t|
      t.integer :contract_id
      t.integer :type_id, size: 8
      t.integer :quantity, size: 8
      t.integer :raw_quantity
      t.boolean :singleton
      t.boolean :included
      t.timestamps
    end
    add_index :contract_items, :type_id
  end
end
