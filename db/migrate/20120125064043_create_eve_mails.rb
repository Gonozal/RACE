class CreateEveMails < ActiveRecord::Migration
  def change
    create_table :eve_mails do |t|
    	t.integer :sender_id
      t.datetime :sent_date
      t.string :title
      t.text :body
      t.integer :to_corp_or_alliance_id
      t.string :to_character_ids
      t.string :to_list_id
      t.timestamps
    end
    add_index :eve_mails, :sender_id
    add_index :eve_mails, :to_corp_or_alliance_id
    add_index :eve_mails, :sent_date
  end
end
