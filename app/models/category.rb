class Category < ActiveRecord::Base
  belongs_to :group
  scope :is_public, ->{ where(public: true)}
end
