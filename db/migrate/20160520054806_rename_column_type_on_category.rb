class RenameColumnTypeOnCategory < ActiveRecord::Migration
  def change
    rename_column :categories,:type, :type_no
  end
end
