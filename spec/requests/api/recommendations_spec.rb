# frozen_string_literal: true

require 'rails_helper'

describe 'api/recommendations', type: :request do
  let!(:rec1) { create(:recommendation, problem_type: 'slow_internet') }
  let!(:rec2) { create(:recommendation, problem_type: 'no_signal') }

  describe 'GET /api/recommendations' do
    context 'without filter' do
      it 'returns all recommendations' do
        get '/api/recommendations'

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.size).to eq(2)
      end
    end

    context 'with problem_type filter' do
      it 'returns filtered recommendations' do
        get '/api/recommendations', params: { problem_type: 'slow_internet' }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.size).to eq(1)
        expect(response.parsed_body.first['problem_type']).to eq('slow_internet')
      end
    end
  end

  describe 'POST /api/recommendations/contextual' do
    let(:headers) { { 'Content-Type': 'application/json' } }

    context 'high ping and slow download' do
      let(:params) do
        {
          ping: 150,
          download_speed: 1.5,
          upload_speed: 0.5
        }
      end

      it 'returns contextual recommendations' do
        post '/api/recommendations/contextual', params: params.to_json, headers: headers

        expect(response).to have_http_status(:ok)
        body = response.parsed_body
        expect(body).to be_an(Array)
        expect(body).to(be_any { |r| r['text'].include?('задержка') })
        expect(body).to(be_any { |r| r['text'].include?('скорость загрузки') })
      end
    end

    context 'normal metrics' do
      let(:params) do
        {
          ping: 20,
          download_speed: 30,
          upload_speed: 10
        }
      end

      it 'returns empty array for normal conditions' do
        post '/api/recommendations/contextual', params: params.to_json, headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq([])
      end
    end
  end
end
