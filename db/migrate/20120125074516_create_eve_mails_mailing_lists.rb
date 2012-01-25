class CreateEveMailsMailingLists < ActiveRecord::Migration
  def change
  	create_table :eve_mails_mailing_lists, id: false do |t|
      t.integer :eve_mail_id
      t.integer :mailing_list_id
      t.timestamps
    end
    add_index :eve_mails_mailing_lists, :eve_mail_id
    add_index :eve_mails_mailing_lists, :mailing_list_id
  end
end
