class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :main_character_id
      t.database_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable

      t.timestamps
    end
    add_index :accounts, :main_character_id
  end
end
