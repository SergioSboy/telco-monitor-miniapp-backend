# frozen_string_literal: true

FactoryBot.define do
  factory :recommendation do
    problem_type { 'MyString' }
    text { 'MyText' }
    link { 'MyString' }
  end
end
