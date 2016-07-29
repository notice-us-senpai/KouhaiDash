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

class Contact < ActiveRecord::Base

  belongs_to :category

  # VALIDATIONS HERE

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << columns
      all.each do |contact|
        csv << contact.attributes.values_at(*columns)
      end
    end
  end
end
