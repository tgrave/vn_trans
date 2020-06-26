json.extract! line, :id, :fragment_id, :who, :content, :who_translated, :content_translated, :created_at, :updated_at
json.updated_by line.updated_by_person
json.url line_url(line, format: :json)
