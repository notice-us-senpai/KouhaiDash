class TextPage < ActiveRecord::Base
  belongs_to :category
  validates :title,
    presence: true
  validates :category_id,
    presence: true
  validates :file_id,
    presence: true, if: "load_from_google"
end
