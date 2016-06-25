Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_API_CLIENT_ID"], ENV["GOOGLE_API_CLIENT_SECRET"],{
    :scope => "email,profile,https://www.googleapis.com/auth/calendar,https://www.googleapis.com/auth/drive.readonly",
    :prompt => "select_account"
  }
end
