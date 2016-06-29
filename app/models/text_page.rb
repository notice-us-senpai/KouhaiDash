class TextPage < ActiveRecord::Base
  belongs_to :category
  belongs_to :google_account

  validates :title,
    presence: true
  validates :category_id,
    presence: true
  validates :file_id,
    presence: true, if: "load_from_google"
end
