class ChangeIndexOfGoogleAccount < ActiveRecord::Migration
  def change
    remove_index :google_accounts, column: :user_id
    add_index :google_accounts, :user_id
  end
end
