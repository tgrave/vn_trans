json.extract! location, :id, :fragment_id, :content, :content_translated, :updated_by, :created_at, :updated_at
json.updated_by location.updated_by_person
json.url location_url(location, format: :json)
