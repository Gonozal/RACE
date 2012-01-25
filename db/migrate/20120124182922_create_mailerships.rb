class CreateMailerships < ActiveRecord::Migration
  def change
    create_table :mailerships do |t|
      t.integer :character_id
      t.integer :mailing_list_id
      t.timestamps
    end
    add_index :mailerships, :character_id
    add_index :mailerships, :mailing_list_id
  end
end
