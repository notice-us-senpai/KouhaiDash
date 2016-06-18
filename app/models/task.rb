class Task < ActiveRecord::Base
  # associations
  belongs_to :category
  has_many :task_assignments
  accepts_nested_attributes_for :task_assignments, allow_destroy: true
  # validations
  validates :name,
    presence: true
  validates :category_id,
    presence: true
end
