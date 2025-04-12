# frozen_string_literal: true

json.array! @complaints do |complaint|
  json.extract! complaint, :id, :problem_type, :comment, :status, :ticket_number, :created_at
end
