# frozen_string_literal: true

require 'telegram/request_validator'
require 'rails_helper'

RSpec.describe '/api/telegram_login', type: :request do
  describe 'POST' do
    let(:user_params) { { telegram_id: 123, first_name: 'Test', last_name: 'User', username: 'test' } }
    let(:init_data) do
      'query_id=AAE9roteAgAAAD2ui157SM56&user=%7B%22id%22%3A5881179709%2C%22first_name%22%3A%22%F0%9F%90%8D%22%2C%22last_name%22%3A%22%22%2C%22username%22%3A%22baz_ko%22%2C%22language_code%22%3A%22ru%22%2C%22allows_write_to_pm%22%3Atrue%2C%22photo_url%22%3A%22https%3A%5C%2F%5C%2Ft.me%5C%2Fi%5C%2Fuserpic%5C%2F320%5C%2FHk0Zk0zms8TenUlIYNvHqFgjauXNctA7XPHCSEaY-i44m6mWpAOjqJIqhrwsy5oi.svg%22%7D&auth_date=1734466893&signature=fvQgJhFEGfODRlLC-IQzrfmAjdrqOlBVHJIM06H14oF3tcPIv-HE-ZD0fJ9_8fZaY4o8-OBwk2UkQo1LlqYsBg&hash=90236c7fd7335b3752e0931d4e370aad9a527fe49ab502b65782a4dc65a5393a'
    end
    let(:params) { { initData: init_data } }
    let(:make_request) { send(:post, '/api/telegram_login', params: params) }

    context 'пользователь зарегистрировался' do
      before do
        allow(Telegram::RequestValidator).to receive(:authenticate).and_return(user_params)
      end

      it 'возвращает статус 201 (created)' do
        make_request
        expect(response).to have_http_status(:created)
      end

      it 'создает пользователя' do
        expect { make_request }.to change(User, :count).by(1)
      end

      it 'рендерит роль в ответе через шаблон' do
        make_request
        expect(response.parsed_body['message']).to eq('Пользователь зарегистрирован')
      end
    end

    context 'пользователь уже существует' do
      let!(:existing_user) { User.create(user_params) }

      before do
        allow(Telegram::RequestValidator).to receive(:authenticate).and_return(user_params)
      end

      it 'возвращает статус 200 (ok)' do
        make_request
        expect(response).to have_http_status(:ok)
      end

      it 'не создает нового пользователя' do
        expect { make_request }.not_to change(User, :count)
      end

      it 'рендерит роль и сообщение' do
        make_request
        expect(response.parsed_body['message']).to eq('Пользователь уже существует')
      end

      context 'пользователь забанен' do
        before { existing_user.update(state: 'banned') }

        it 'возвращает статус 403' do
          make_request
          expect(response).to have_http_status(:forbidden)
        end

        it 'рендерит сообщение об ошибке' do
          make_request
          expect(response.parsed_body['message']).to eq('Ошибка доступа. Попробуйте позже.')
        end
      end
    end

    context 'невалидные данные' do
      let(:params) { {} }

      before do
        allow(Telegram::RequestValidator).to receive(:authenticate).and_return(false)
      end

      it 'возвращает статус 400 (bad request)' do
        make_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'рендерит сообщение об ошибке' do
        make_request
        expect(response.parsed_body['message']).to eq('Ошибка авторизации')
      end
    end
  end
end
