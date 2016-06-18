class RenamePublicToIsPublicInCategories < ActiveRecord::Migration
  def change
    rename_column :categories, :public, :is_public
    change_column_default :categories, :is_public, true
  end
end
