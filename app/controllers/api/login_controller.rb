# frozen_string_literal: true

module API
  class LoginController < ApplicationController
    def telegram_login
      result = TelegramLoginService.new(telegram_params).call
      render json: { message: result[:message] }, status: result[:status]
    end

    private

    def telegram_params
      params.require(:initData)
    end
  end
end
