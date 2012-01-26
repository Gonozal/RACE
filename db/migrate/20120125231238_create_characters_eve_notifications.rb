class CreateCharactersEveNotifications < ActiveRecord::Migration  
	def change
    create_table :characters_eve_notifications, id: false do |t|
      t.integer :character_id
      t.integer :eve_notification_id
    end
    add_index :characters_eve_notifications, :character_id
    add_index :characters_eve_notifications, :eve_notification_id
  end
end
