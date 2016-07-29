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

require 'test_helper'

class CalendarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
