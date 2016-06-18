class AddMembersPublicToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :members_public, :boolean
    change_column_default :groups, :members_public, true
  end
end
