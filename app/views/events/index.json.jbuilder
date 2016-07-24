json.array!(@events) do |event|
  json.extract! event, :id, :calendar_id, :name, :location, :description, :start, :end
  json.url event_url(event, format: :json)
end
