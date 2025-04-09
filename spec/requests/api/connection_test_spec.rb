# frozen_string_literal: true

require 'rails_helper'

describe 'api/connection_tests', type: :request do
  let(:http_method) { :get }
  let(:make_request) { send(http_method, '/api/connection_tests', params: params) }
  let(:user) { create(:user) }
  let(:params) { {} }

  before do
    authenticate(user)
  end

  context 'POST' do
    let(:http_method) { :post }

    let(:valid_params) do
      {
        connection_test: {
          ping: 20.5,
          download_speed: 50.2,
          upload_speed: 12.8,
          latitude: 55.7558,
          longitude: 37.6173
        }
      }
    end

    let(:params) { valid_params }

    context 'valid params' do
      it 'status ok' do
        make_request

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['message']).to eq('ok')
      end

      it 'add connection_test' do
        expect { make_request }.to change(ConnectionTest, :count).by(1)
      end
    end

    context 'invalid params' do
      let(:invalid_params) do
        valid_params.deep_merge(connection_test: { ping: nil })
      end
      let(:params) { invalid_params }

      it 'returns 422 when params are invalid' do
        make_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to include("can't be blank")
      end
    end
  end
end
