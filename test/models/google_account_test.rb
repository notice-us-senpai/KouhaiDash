# == Schema Information
#
# Table name: google_accounts
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  access_token  :string
#  refresh_token :string
#  expires_at    :datetime
#  gmail         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class GoogleAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
