class AddStringIdToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :string_id, :string
    add_column :groups, :description, :text
    add_index(:groups, :string_id, unique: true)
  end

end
