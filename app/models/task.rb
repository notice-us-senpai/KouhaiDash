class Task < ActiveRecord::Base
  belongs_to :category
  has_many :task_assignments
  accepts_nested_attributes_for :task_assignments, allow_destroy: true
end
