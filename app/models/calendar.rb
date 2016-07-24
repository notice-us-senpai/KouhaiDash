class Calendar < ActiveRecord::Base
  has_many :events, dependent: :destroy
  belongs_to :category
  belongs_to :google_account

  validates :category_id,
    presence: true
end
