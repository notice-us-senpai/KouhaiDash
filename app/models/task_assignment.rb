class TaskAssignment < ActiveRecord::Base
  belongs_to :tasks
  belongs_to :membership
end
