# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    telegram_id { Faker::Number.between(from: 1, to: 10_000_000) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.username(specifier: first_name) }
  end
end
