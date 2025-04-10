# frozen_string_literal: true

class Complaint < ApplicationRecord
  belongs_to :user

  validates :problem_type, :latitude, :longitude, :comment, presence: true

  before_create :assign_ticket

  private

  def assign_ticket
    self.ticket_number = "TICKET_#{SecureRandom.hex(4).upcase}"
    self.status ||= 'pending'
  end
end
