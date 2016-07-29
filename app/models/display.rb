class Display < ActiveRecord::Base
  belongs_to :category
  belongs_to :google_account

  validates :display_type,
    presence: true
end
