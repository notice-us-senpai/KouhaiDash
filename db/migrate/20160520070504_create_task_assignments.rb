class CreateTaskAssignments < ActiveRecord::Migration
  def change
    create_table :task_assignments do |t|
      t.integer :task_id
      t.integer :membership_id

      t.timestamps null: false
    end
    add_index :task_assignments, :tasks
    add_index :task_assignments, :membership_id
  end
end
