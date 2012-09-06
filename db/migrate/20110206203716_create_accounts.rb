class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :password_digest
      t.integer :main_character_id
      t.string :email
      t.string :forgot_password_hash

      t.timestamps
    end
    add_index :accounts, :name
  end
end
