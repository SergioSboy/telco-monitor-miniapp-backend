# frozen_string_literal: true

class ConnectionTest < ApplicationRecord
  belongs_to :user

  validates :ping, :download_speed, :upload_speed, presence: true
end
