# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post 'telegram_login', to: 'login#telegram_login'
    get 'health', to: 'health#show'
  end
end
