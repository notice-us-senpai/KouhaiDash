class AddCateorgyIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :category_id, :integer
  end
  add_index :tasks, :category_id
end
