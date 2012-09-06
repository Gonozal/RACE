class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :main_character_id
      t.database_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.token_authenticatable

      t.timestamps
    end
    add_index :accounts, :name
    add_index :accounts, :main_character_id
  end
end
