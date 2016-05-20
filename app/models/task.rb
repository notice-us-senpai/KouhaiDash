class Task < ActiveRecord::Base
  belongs_to :category
  has_many :task_assignments
end
