# frozen_string_literal: true

require 'rails_helper'

describe 'api/complaints', type: :request do
  let(:http_method) { :post }
  let(:make_request) { send(http_method, '/api/complaints', params: params.to_json, headers: headers) }
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/json' } }

  let(:valid_params) do
    {
      complaint: {
        problem_type: 'slow_internet',
        comment: 'интернет пропадает каждые 5 минут',
        latitude: 55.7558,
        longitude: 37.6173
      }
    }
  end

  before do
    authenticate(user)
  end

  context 'valid params' do
    let(:params) { valid_params }

    it 'returns status ok' do
      make_request

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['message']).to eq('ok')
      expect(response.parsed_body['ticket_number']).to be_present
    end

    it 'creates a new complaint' do
      expect { make_request }.to change(Complaint, :count).by(1)
    end
  end

  context 'invalid params' do
    let(:params) do
      valid_params.deep_merge(complaint: { problem_type: nil })
    end

    it 'returns 422 for missing problem_type' do
      make_request

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['message']).to include("can't be blank")
    end
  end
end
