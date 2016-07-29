# == Schema Information
#
# Table name: text_pages
#
#  id                :integer          not null, primary key
#  category_id       :integer
#  title             :string
#  contents          :text
#  load_from_google  :boolean
#  file_id           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  google_account_id :integer
#

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
