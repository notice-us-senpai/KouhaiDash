json.array!(@text_pages) do |text_page|
  json.extract! text_page, :id, :category_id, :title, :contents, :load_from_google, :file_id
  json.url text_page_url(text_page, format: :json)
end
