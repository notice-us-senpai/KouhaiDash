class AddCategoryIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :category_id, :integer
  end
end
