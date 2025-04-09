# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module TelcoMonitorMiniappBackend
  class Application < Rails::Application
    config.load_defaults 8.0

    config.middleware.use ActionDispatch::Cookies
    config.autoload_lib(ignore: %w[assets tasks])
    config.eager_load = true
    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('lib')
    if Rails.env.development?
      config.middleware.use ActionDispatch::Session::CookieStore,
                            key: '_telegram_session',
                            same_site: :lax,
                            secure: false
    else
      config.middleware.use ActionDispatch::Session::CookieStore,
                            key: '_telegram_session',
                            same_site: :none,
                            secure: true
    end

    config.api_only = true
  end
end
