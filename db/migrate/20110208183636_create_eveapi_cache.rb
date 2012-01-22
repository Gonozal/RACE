class CreateEveapiCache < ActiveRecord::Migration
  def change
    create_table :eveapi_cache do |t|
      t.string :request_hash
      t.text :xml
      t.datetime :cached_until
      
      t.timestamps
    end
    add_index :eveapi_cache, :request_hash
  end
end
