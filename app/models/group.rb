class Group < ActiveRecord::Base
  has_many :categories, dependent: :destroy
  has_many :users, through: :memberships
end
