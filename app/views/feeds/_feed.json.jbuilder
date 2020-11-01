json.extract! feed, :id, :url, :name, :link, :created_at, :updated_at
json.url feed_url(feed, format: :json)
