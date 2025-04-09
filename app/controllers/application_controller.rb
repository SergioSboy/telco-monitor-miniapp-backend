# frozen_string_literal: true

class ApplicationController < ActionController::API
  def current_user
    Rails.logger.info 'Проверям куки пользователя'
    return unless session[:id]

    Rails.logger.info "Ищем пользователя с данными из куки user_id - #{session[:id]}"
    @current_user ||= User.find(session[:id])
  end

  def check_access(user = nil)
    Rails.logger.info 'Проверям забанен ли пользователь'
    if user.nil?
      return unless current_user.banned?

      render json: { message: 'Ошибка доступа. Попробуйте позже.' }, status: :forbidden
    else
      user.banned?
    end
  end
end
