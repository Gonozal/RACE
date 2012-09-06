class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.integer :api_id
      t.string :v_code
      t.string :registration_token

      t.timestamps
    end
  end
end
