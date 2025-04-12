# frozen_string_literal: true

module Api
  class ComplaintsController < ConnectionTestsController
    def index
      @complaints = current_user.complaints.order(created_at: :desc)
    end

    def create
      @complaint = current_user.complaints.create!(complaint_params)
      render json: { message: 'ok', ticket_number: @complaint.ticket_number }, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    private

    def complaint_params
      params.expect(complaint: %i[problem_type comment latitude longitude])
    end
  end
end
