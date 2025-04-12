# frozen_string_literal: true

# spec/factories/recommendations.rb
FactoryBot.define do
  factory :recommendation do
    problem_type { 'slow_internet' }
    text { 'Переключитесь с 5G на 4G.' }
    latitude { 55.75 }
    longitude { 37.61 }
    upvotes { 0 }
    downvotes { 0 }
  end
end
