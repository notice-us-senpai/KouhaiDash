class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :task_assignments
  has_many :tasks, through: :task_assignments
end
