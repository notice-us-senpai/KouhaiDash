# == Schema Information
#
# Table name: contacts
#
#  id           :integer          not null, primary key
#  name         :string
#  organisation :string
#  position     :string
#  email        :string
#  phone        :string
#  website      :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category_id  :integer
#

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
