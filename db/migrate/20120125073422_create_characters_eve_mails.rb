class CreateCharactersEveMails < ActiveRecord::Migration
  def change
    create_table :characters_eve_mails, id: false do |t|
      t.integer :character_id
      t.integer :eve_mail_id
      t.timestamps
    end
    add_index :characters_eve_mails, :character_id
    add_index :characters_eve_mails, :eve_mail_id
  end
end
