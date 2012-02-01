class CreateSoAwesomes < ActiveRecord::Migration
  def change
    create_table :so_awesomes do |t|

      t.timestamps
    end
  end
end
