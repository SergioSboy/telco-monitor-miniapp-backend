# frozen_string_literal: true

module Api
  class LoginController < ApplicationController
    def telegram_login
      parsed_data = Telegram::TelegramRequestValidator.authenticate(telegram_params)
      return render json: { message: 'Ошибка авторизации' }, status: :unauthorized unless parsed_data

      user = User.find_by(telegram_id: parsed_data[:telegram_id])

      if user
        Rails.logger.info "Пользователь #{user} существует, проверяем доступ к ресурсам"
        return render json: { message: 'Ошибка доступа. Попробуйте позже.' }, status: :forbidden if check_access(user)
      else
        Rails.logger.info 'Пользователь заходит первый раз'
        user = User.create(parsed_data)
      end

      Rails.logger.info "Выдаем куки с user_id - #{user.id}"

      session[:id] = user.id
      render json: { message: 'Вход выполнен' }, status: :ok
    end

    private

    def telegram_params
      params.require(:initData)
    end
  end
end
