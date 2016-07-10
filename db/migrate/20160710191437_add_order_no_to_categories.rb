class AddOrderNoToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :order_no, :integer
  end
end
