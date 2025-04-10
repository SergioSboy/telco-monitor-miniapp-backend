# frozen_string_literal: true

FactoryBot.define do
  factory :complaint do
    user { nil }
    problem_type { 'MyString' }
    comment { 'MyText' }
    latitude { 1.5 }
    longitude { 1.5 }
    ticket_number { 'MyString' }
    status { 'MyString' }
  end
end
