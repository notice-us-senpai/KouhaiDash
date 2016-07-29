# == Schema Information
#
# Table name: task_assignments
#
#  id            :integer          not null, primary key
#  task_id       :integer
#  membership_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class TaskAssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
