class TaskAssignment < ActiveRecord::Base
  # associations
  belongs_to :task
  belongs_to :membership
  # validations
  validates :task_id,
    presence: true
  validates :membership_id,
    presence: true,
    uniqueness: {scope: :task_id}
end
