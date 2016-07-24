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
  validates :string_id,
    uniqueness: { case_sensitive: false },
    format: { with: /\A[a-zA-Z0-9_-]+\Z/, message: "only allows letters, digits, hyphens and underscores"}

  before_save { self.string_id = string_id.downcase }

end
