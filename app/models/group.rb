# == Schema Information
#
# Table name: groups
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  members_public :boolean          default(TRUE)
#  string_id      :string
#  description    :text
#

class Group < ActiveRecord::Base
  # associations
  has_many :categories, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :tasks, through: :categories
  has_many :task_assignments, through: :tasks
  has_many :calendars, through: :categories
  has_many :events, through: :calendars
  has_many :text_pages, through: :categories
  has_many :contacts, through: :categories
  # validations
  validates :name,
    presence: true
  validates :string_id,
    uniqueness: { case_sensitive: false },
    format: { with: /\A[A-Za-z0-9_-]+\Z/, message: "only allows letters, digits, hyphens and underscores"}


end
