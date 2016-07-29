# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string
#  deadline    :date
#  description :text
#  done        :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#

class Task < ActiveRecord::Base
  # associations
  belongs_to :category
  has_many :task_assignments, dependent: :destroy
  accepts_nested_attributes_for :task_assignments, allow_destroy: true
  # validations
  validates :name,
    presence: true
  validates :category_id,
    presence: true
end
