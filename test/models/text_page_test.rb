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

require 'test_helper'

class TextPageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
