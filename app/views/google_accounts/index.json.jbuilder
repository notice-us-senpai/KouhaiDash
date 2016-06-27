json.array!(@google_accounts) do |google_account|
  json.extract! google_account, :id, :user_id, :access_token, :refresh_token, :expires_at, :gmail
  json.url google_account_url(google_account, format: :json)
end
