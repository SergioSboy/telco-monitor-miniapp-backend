# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post 'telegram_login', to: 'login#telegram_login'
    get 'health', to: 'health#show'

    resources :connection_tests, only: [:create]
    resources :complaints, only: [:create]
    resources :recommendations, only: [:index] do
      member do
        post :feedback
      end
      collection do
        post :contextual
        get :map
      end
    end
  end
end
