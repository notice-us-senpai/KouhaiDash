# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  calendar_id :integer
#  summary     :string
#  location    :string
#  description :text
#  start       :datetime
#  end         :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Event < ActiveRecord::Base
  belongs_to :calendar

  validates :summary,
    presence: true
  validates :calendar_id,
    presence: true
  validate :start_cannot_be_after_than_end

  private
  def start_cannot_be_after_than_end
    unless start
      errors.add(:start,"can't be blank")
    end
    unless self.end
      errors.add(:end,"can't be blank")
    end
    if start && self.end && start > self.end
      errors.add(:start, "can't be after than End datetime")
    end
  end

end
