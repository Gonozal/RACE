class CreateEveNotifications < ActiveRecord::Migration
  def change
    create_table :eve_notifications do |t|
      t.integer :type_id
      t.integer :sender_id
      t.datetime :sent_date
      t.boolean :read
      t.text :content
      t.timestamps
    end
    add_index :eve_notifications, :read
    add_index :eve_notifications, :type_id
    add_index :eve_notifications, :sender_id
  end
end
