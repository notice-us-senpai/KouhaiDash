class CreateTextPages < ActiveRecord::Migration
  def change
    create_table :text_pages do |t|
      t.integer :category_id
      t.string :title
      t.text :contents
      t.boolean :load_from_google
      t.string :file_id

      t.timestamps null: false
    end
    add_index :text_pages, :category_id
  end
end
