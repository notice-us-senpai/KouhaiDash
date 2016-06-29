class AddGoogleAccountIdToTextPage < ActiveRecord::Migration
  def change
    add_column :text_pages, :google_account_id, :integer
    add_index :text_pages, :google_account_id
  end
end
