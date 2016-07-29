# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  type_no    :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_public  :boolean          default(TRUE)
#  order_no   :integer
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
