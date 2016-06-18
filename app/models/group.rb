class Group < ActiveRecord::Base
  # associations
  has_many :categories, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :tasks, through: :categories
  has_many :task_assignments, through: :tasks
  # validations
  validates :name,
    presence: true
end
