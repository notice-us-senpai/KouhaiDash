class User < ActiveRecord::Base
	before_save { self.email = email.downcase }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :username, 
						presence: true, 
						length: { minimum: 4, maximum: 16 }, 
						uniqueness: { case_sensitive: false }
	validates :email, 
						presence: true, 
						format: { with: VALID_EMAIL_REGEX }, 
						length: { maximum: 64 }, 
						uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, 
						presence: true, 
						length: { minimum: 8 }, 
						confirmation: true
end
