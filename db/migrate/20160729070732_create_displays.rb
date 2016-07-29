class CreateDisplays < ActiveRecord::Migration
  def change
    create_table :displays do |t|
      t.integer :category_id
      t.integer :google_account_id
      t.string :google_folder_id
      t.integer :display_type

      t.timestamps null: false
    end
    add_index :displays, :category_id
    add_index :displays, :google_account_id
  end
end
