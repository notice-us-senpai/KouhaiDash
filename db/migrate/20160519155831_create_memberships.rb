class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :group_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :memberships, :group_id
    add_index :memberships, :user_id
  end
end
