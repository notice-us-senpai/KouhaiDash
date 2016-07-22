class Event < ActiveRecord::Base
  belongs_to :calendar

  validates :summary,
    presence: true
  validates :start,
    presence: true
  validates :end,
    presence: true
  validates :calendar_id,
    presence: true
end
