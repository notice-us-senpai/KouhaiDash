class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :calendar_id
      t.string :name
      t.string :location
      t.text :description
      t.datetime :start
      t.datetime :end

      t.timestamps null: false
    end
  end
end
