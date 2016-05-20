class Group < ActiveRecord::Base
  has_many :categories, dependent: :destroy
  has_many :users, through: :memberships
  has_many :tasks, through: :categories
  has_many :task_assignments, through: :tasks
end
