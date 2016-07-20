class Calendar < ActiveRecord::Base
  has_many :events, dependent: :destroy
  belongs_to :category

  validates :category_id,
    presence: true
end
