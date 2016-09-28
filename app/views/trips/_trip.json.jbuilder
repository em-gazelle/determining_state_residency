json.extract! trip, :id, :start_date, :end_date, :state, :total_days
json.url trip_url(trip, format: :json)