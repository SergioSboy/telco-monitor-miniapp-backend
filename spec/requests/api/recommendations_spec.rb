# frozen_string_literal: true

require 'rails_helper'

describe 'api/recommendations', type: :request do
  let!(:rec1) { create(:recommendation, problem_type: 'slow_internet') }
  let!(:rec2) { create(:recommendation, problem_type: 'no_signal') }

  let!(:far_rec) do
    create(:recommendation, latitude: 60.00, longitude: 30.00)
  end
  let!(:nearby_rec) do
    create(:recommendation, latitude: 55.75, longitude: 37.61)
  end

  describe 'GET /api/recommendations' do
    context 'without filter' do
      it 'returns all recommendations' do
        get '/api/recommendations'

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.size).to eq(4)
      end
    end

    context 'with problem_type filter' do
      it 'returns filtered recommendations' do
        get '/api/recommendations', params: { problem_type: 'slow_internet' }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.size).to eq(3)
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

  describe 'GET /api/recommendations/map' do
    it 'returns nearby recommendations' do
      get '/api/recommendations/map', params: { lat: 55.75, lng: 37.61 }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.map { |r| r['id'] }).to include(nearby_rec.id)
      expect(response.parsed_body.map { |r| r['id'] }).not_to include(far_rec.id)
    end

    it 'returns empty if no recommendations nearby' do
      get '/api/recommendations/map', params: { lat: 0, lng: 0 }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq([])
    end
  end

  describe 'POST /api/recommendations/:id/feedback' do
    it 'increments upvote counter' do
      expect do
        post "/api/recommendations/#{nearby_rec.id}/feedback", params: { vote: 'up' }
      end.to change { nearby_rec.reload.upvotes }.by(1)

      expect(response).to have_http_status(:ok)
    end

    it 'increments downvote counter' do
      expect do
        post "/api/recommendations/#{nearby_rec.id}/feedback", params: { vote: 'down' }
      end.to change { nearby_rec.reload.downvotes }.by(1)

      expect(response).to have_http_status(:ok)
    end

    it 'returns 422 on invalid vote' do
      post "/api/recommendations/#{nearby_rec.id}/feedback", params: { vote: 'invalid' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['error']).to eq('Invalid vote type')
    end
  end
end
