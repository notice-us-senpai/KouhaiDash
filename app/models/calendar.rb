# == Schema Information
#
# Table name: calendars
#
#  id                 :integer          not null, primary key
#  name               :string
#  category_id        :integer
#  google_calendar_id :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  google_account_id  :integer
#  time_zone          :string
#

class Calendar < ActiveRecord::Base
  has_many :events, dependent: :destroy
  belongs_to :category
  belongs_to :google_account

  validates :category_id,
    presence: true
end
