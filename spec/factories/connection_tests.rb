# frozen_string_literal: true

FactoryBot.define do
  factory :connection_test do
    user { nil }
    ping { 1.5 }
    download_speed { 1.5 }
    upload_speed { 1.5 }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end
