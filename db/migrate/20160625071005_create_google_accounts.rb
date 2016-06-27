class CreateGoogleAccounts < ActiveRecord::Migration
  def change
    create_table :google_accounts do |t|
      t.integer :user_id
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.string :gmail

      t.timestamps null: false
    end
    add_index(:google_accounts, :user_id, unique: true)
    add_index(:google_accounts, :gmail, unique: true)
  end
end
