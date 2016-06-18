class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.date :deadline
      t.text :description
      t.boolean :done

      t.timestamps null: false
    end
  end
end
