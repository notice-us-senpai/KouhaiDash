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
