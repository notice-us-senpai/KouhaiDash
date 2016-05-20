json.array!(@categories) do |category|
  json.extract! category, :id, :name, :type_no, :group_id
  json.url category_url(category, format: :json)
end
