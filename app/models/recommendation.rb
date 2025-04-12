# frozen_string_literal: true

class Recommendation < ApplicationRecord
  validates :problem_type, :text, presence: true

  def rate!(type)
    case type
    when :up then increment!(:upvotes)
    when :down then increment!(:downvotes)
    end
  end
end
