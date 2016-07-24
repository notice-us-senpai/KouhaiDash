class AddGoogleAccountIdToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :google_account_id, :integer
    add_index :calendars, :google_account_id
  end
end
