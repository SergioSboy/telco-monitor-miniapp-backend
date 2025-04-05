# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Основные гемы
gem 'pg'                       # Использование PostgreSQL в качестве базы данных
gem 'puma'                     # Веб-сервер Puma
gem 'rails'
gem 'redis'
gem 'sidekiq'
# Опции для разных сред
group :development, :test do
  gem 'annotate'               # Схема базы данных в моделях и фабриках
  gem 'brakeman'               # Анализатор кода на уязвимости
  gem 'bundler-audit'          # Проверка Gemfile и Gemfile.lock на уязвимости
  gem 'byebug'                 # Отладчик
  gem 'capybara'               # Тестирование веб-интерфейсов
  gem 'codecov'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'           # Гем, для взаимодействия с переменными окружения
  gem 'factory_bot_rails'      # Настройка фейковых данных для тестирования
  gem 'faker'                  # Фейковые данные для тестирования
  gem 'letter_opener'          # Отправка писем
  gem 'rspec'                  # Базовый RSpec (вместе с `rspec-rails`)
  gem 'rspec-rails'            # Основной гем для тестирования
  gem 'rspec-sidekiq'
  gem 'rubocop'                # Статический анализатор кода
  gem 'rubocop-performance'
  gem 'rubocop-rails'          # Линтер для Ror
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'ruby_audit'             # Проверка ruby на уязвимости
  gem 'selenium-webdriver'     # Для работы с Capybara
  gem 'simplecov'              # Отчет покрытия кодом
  gem 'webmock'                # Мокирование HTTP-запросов
end

group :test do
  gem 'database_cleaner-active_record'
end

# Прочие полезные гемы
gem 'active_model_serializers' # Сериализация данных для API
gem 'bcrypt', '~> 3.1.7'       # Хеширование паролей
gem 'jwt'                      # Работа с JSON Web Tokens (JWT)
gem 'rack-cors'                # Поддержка CORS запросов

# Windows специфичные гемы
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Оптимизация загрузки приложения
gem 'bootsnap', require: false

# Валидация email
gem 'valid_email'

gem 'rexml', '>= 3.3.6'

# Удобное предсставление ответов на запросы
gem 'jbuilder'

gem 'http'
