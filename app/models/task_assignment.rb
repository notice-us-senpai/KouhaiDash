# == Schema Information
#
# Table name: task_assignments
#
#  id            :integer          not null, primary key
#  task_id       :integer
#  membership_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TaskAssignment < ActiveRecord::Base
  # associations
  belongs_to :task
  belongs_to :membership
  # validations
  validates :membership_id,
    presence: true,
    uniqueness: {scope: :task_id}
end
