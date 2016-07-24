class User < ActiveRecord::Base
  def to_param
    username
  end

  # 0 - ordinary community user
  # 1 - community administrator
  # 2 - kouhaidash administrator

	attr_accessor :remember_token

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :task_assignments, through: :memberships
  has_many :tasks, through: :memberships
  has_one :google_account

	before_save { self.email = email.downcase }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :username,
						presence: true,
						length: { minimum: 4, maximum: 16 },
						uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9_-]+\Z/, message: "only allows letters, digits, hyphens and underscores"}
	validates :email,
						presence: true,
						format: { with: VALID_EMAIL_REGEX },
						length: { maximum: 64 },
						uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password,
						presence: true,
						length: { minimum: 8 },
						confirmation: true,
            allow_nil: true

	# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
    	BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
