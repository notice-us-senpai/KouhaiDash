class RenameNameToSummaryOnEvents < ActiveRecord::Migration
  def change
    rename_column :events, :name, :summary
    add_index :events, :start
    add_index :events, :end
    add_index :events, :calendar_id
    add_index :calendars, :category_id
  end
end
