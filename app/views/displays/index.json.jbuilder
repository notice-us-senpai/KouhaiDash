json.array!(@displays) do |display|
  json.extract! display, :id, :category_id, :google_account_id, :google_folder_id, :display_type
  json.url display_url(display, format: :json)
end
