# frozen_string_literal: true

class TelegramLoginService
  def initialize(data)
    @data = data
  end

  def call
    parsed_data = Telegram::RequestValidator.authenticate(@data)
    return failure('Ошибка авторизации', :unauthorized) unless parsed_data

    user = User.find_by(telegram_id: parsed_data[:telegram_id])
    if user
      return failure('Ошибка доступа. Попробуйте позже.', :forbidden) if check_access(user)

      success('Пользователь уже существует', user, :ok)
    else
      user = User.create(parsed_data)
      if user.persisted?
        success('Пользователь зарегистрирован', user,
                :created)
      else
        failure('Ошибка регистрации', :unprocessable_entity)
      end
    end
  end

  private

  def success(message, user, status)
    { status:, success: true, user:, message: }
  end

  def failure(message, status)
    { status:, success: false, message: }
  end

  def check_access(_user)
    false
  end
end
