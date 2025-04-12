# frozen_string_literal: true

class AddGeoAndFeedbackToRecommendations < ActiveRecord::Migration[8.0]
  def change
    add_column :recommendations, :latitude, :float
    add_column :recommendations, :longitude, :float
    add_column :recommendations, :upvotes, :integer
    add_column :recommendations, :downvotes, :integer
  end
end
