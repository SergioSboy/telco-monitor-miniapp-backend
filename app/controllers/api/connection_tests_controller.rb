# frozen_string_literal: true

module Api
  class ConnectionTestsController < ApplicationController
    def create
      current_user.connection_tests.create!(connection_tests_params)

      render json: { message: 'ok' }, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    private

    def connection_tests_params
      params.expect(
        connection_test: %i[ping
                            download_speed
                            upload_speed
                            latitude
                            longitude]
      )
    end
  end
end
