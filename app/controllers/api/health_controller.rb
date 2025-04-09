# frozen_string_literal: true

module Api
  class HealthController < ApplicationController
    def show
      render json: { status: 'OK' }, status: :ok
    end
  end
end
