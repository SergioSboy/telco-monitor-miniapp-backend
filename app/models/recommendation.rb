# frozen_string_literal: true

class Recommendation < ApplicationRecord
  validates :problem_type, :text, presence: true
end
