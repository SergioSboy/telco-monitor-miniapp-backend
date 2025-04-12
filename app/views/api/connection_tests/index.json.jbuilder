# frozen_string_literal: true

json.array! @tests do |test|
  json.extract! test, :id, :ping, :download_speed, :upload_speed, :latitude, :longitude, :created_at
end
