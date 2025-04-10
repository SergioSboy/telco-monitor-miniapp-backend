# frozen_string_literal: true

module Api
  class ComplaintsController < ConnectionTestsController
    def create
      current_user.complaints.create!(complaint_params)
      render json: { message: 'ok' }, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    private

    def complaint_params
      params.expect(complaint: %i[problem_type comment latitude longitude])
    end
  end
end
