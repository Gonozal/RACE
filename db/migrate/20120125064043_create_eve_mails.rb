class CreateEveMails < ActiveRecord::Migration
  def change
    create_table :eve_mails do |t|
    	t.integer :sender_id
      t.datetime :sent_date
      t.string :title
      t.integer :corporation_id
      t.integer :alliance_id
      t.timestamps
    end
    add_index :eve_mails, :sender_id
    add_index :eve_mails, :corporation_id
    add_index :eve_mails, :alliance_id
    add_index :eve_mails, :sent_date
  end
end
