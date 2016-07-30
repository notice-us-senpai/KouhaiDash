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

class Category < ActiveRecord::Base
  # associations
  belongs_to :group
  has_many :tasks, dependent: :destroy
  has_many :task_assignments, through: :tasks
  has_one :text_page, dependent: :destroy
  has_one :calendar, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_one :display, dependent: :destroy
  scope :is_public, ->{ where(is_public: true)}
  # validations
  validates :name,
    presence: true
  validates :type_no,
    presence: true
  validates :group_id,
    presence: true

  before_save :set_order_no

  private
    def set_order_no
      unless order_no
        self.order_no=Time.now.to_i
      end
    end
end
