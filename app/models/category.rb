class Category < ActiveRecord::Base
  belongs_to :group
  has_many :tasks
  has_many :task_assignments, through: :tasks
  scope :is_public, ->{ where(public: true)}
end
