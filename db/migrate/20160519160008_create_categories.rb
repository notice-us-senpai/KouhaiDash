class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :type
      t.integer :group_id

      t.timestamps null: false
    end
    add_index :categories, :group_id
  end
end
