class Category < ActiveRecord::Base
  # associations
  belongs_to :group
  has_many :tasks, dependent: :destroy
  has_many :task_assignments, through: :tasks
  scope :is_public, ->{ where(is_public: true)}
  # validations
  validates :name,
    presence: true
  validates :type_no,
    presence: true
  validates :group_id,
    presence: true
end
