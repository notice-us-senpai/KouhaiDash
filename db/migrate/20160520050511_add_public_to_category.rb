class AddPublicToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :public, :boolean
  end
end
