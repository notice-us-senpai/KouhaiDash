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
    format: { with: /\A[a-z0-9_-]+\Z/, message: "only allows lowercase letters, digits, hyphens and underscores"}

  before_validation { self.string_id = string_id.downcase }

end
