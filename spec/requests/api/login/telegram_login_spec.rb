# frozen_string_literal: true

require 'rails_helper'
RSpec.describe '/api/telegram_login', type: :request do
  describe 'POST' do
    let(:user_params) { { telegram_id: 123, first_name: 'Test', last_name: 'User', username: 'test' } }
    let(:init_data) do
      'query_telegram_params'
    end
    let(:params) { { initData: init_data } }
    let(:make_request) { post '/api/telegram_login', params: params }

    context 'пользователь зарегистрировался' do
      before do
        allow(Telegram::TelegramRequestValidator).to receive(:authenticate).and_return(user_params)
      end

      it 'возвращает статус 200 (created)' do
        make_request
        expect(response).to have_http_status(:ok)
      end

      it 'создает пользователя' do
        expect { make_request }.to change(User, :count).by(1)
      end
    end

    context 'пользователь уже существует' do
      let!(:existing_user) { User.create(user_params) }

      before do
        allow(Telegram::TelegramRequestValidator).to receive(:authenticate).and_return(user_params)
      end

      it 'возвращает статус 200 (ok)' do
        make_request
        expect(response).to have_http_status(:ok)
      end

      it 'не создает нового пользователя' do
        expect { make_request }.not_to change(User, :count)
      end

      context 'пользователь забанен' do
        before do
          existing_user.update(state: 'banned')
        end

        it 'возвращает статус 403' do
          make_request
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'невалидные данные' do
      let(:params) { {} }

      before do
        allow(Telegram::TelegramRequestValidator).to receive(:authenticate).and_return(false)
      end

      it 'возвращает статус :bad_request' do
        make_request
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
