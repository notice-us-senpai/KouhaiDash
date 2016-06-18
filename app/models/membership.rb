class Membership < ActiveRecord::Base
  # associations
  belongs_to :group
  belongs_to :user
  has_many :task_assignments
  has_many :tasks, through: :task_assignments
  # validations
  validates :user_id,
    presence: true,
    uniqueness:{scope: :group_id}
  validates :group_id, presence: true
end
