# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  approved   :boolean          default(FALSE)
#

class Membership < ActiveRecord::Base
  # associations
  belongs_to :group
  belongs_to :user
  has_many :task_assignments, dependent: :destroy
  has_many :tasks, through: :task_assignments
  # validations
  validates :user_id,
    presence: true,
    uniqueness:{scope: :group_id}
  validates :group_id, presence: true
end
