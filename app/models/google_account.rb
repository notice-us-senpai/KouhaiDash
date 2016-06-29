require 'net/http'
require 'json'

class GoogleAccount < ActiveRecord::Base
  before_validation :lower_gmail
  #associations
  belongs_to :user
  has_many :text_pages
  #validations
  validates :gmail,
	 presence: true,
   uniqueness: { case_sensitive: false }
  validates :user_id,
    presence: true

    def to_params
      {'refresh_token' => refresh_token,
      'client_id' => ENV.fetch('GOOGLE_API_CLIENT_ID'),
      'client_secret' => ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      'grant_type' => 'refresh_token'}
    end

    def request_token_from_google
      url = URI("https://accounts.google.com/o/oauth2/token")
      Net::HTTP.post_form(url, self.to_params)
    end

    def refresh!
      response = request_token_from_google
      data = JSON.parse(response.body)
      if response.code=='200'
        update_attributes(access_token: data['access_token'],expires_at: Time.now + (data['expires_in'].to_i).seconds)
      else
        update_attributes(access_token: '')
      end
    end

    def expired?
      expires_at < Time.now
    end

    def fresh_token
      refresh! if expired?
      access_token
    end

  protected
    def lower_gmail
      self.gmail = self.gmail.downcase
    end
end
