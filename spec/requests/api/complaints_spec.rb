# frozen_string_literal: true

require 'rails_helper'

describe 'api/complaints', type: :request do
  let(:http_method) { :post }
  let(:make_request) { send(http_method, '/api/complaints', params: params.to_json, headers: headers) }
  let(:params) { {} }
  let!(:user) { create(:user) }
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

  context  "GET" do
    let!(:http_method) { :get }
    let!(:complaint_1) { create(:complaint, user: user, problem_type: 'нет сигнала') }
    let!(:complaint_2) { create(:complaint, user: user, problem_type: 'медленный интернет') }
    let!(:other_user_complaint) { create(:complaint) }


    it 'returns only current_user complaints' do
      make_request

      expect(response).to have_http_status(:ok)
      body = response.parsed_body

      expect(body.size).to eq(2)
      expect(body.map { |c| c['problem_type'] }).to contain_exactly('нет сигнала', 'медленный интернет')
    end

    it 'includes required fields' do
      make_request

      body = response.parsed_body.first
      expect(body.keys).to include('id', 'problem_type', 'comment', 'status', 'ticket_number', 'created_at')
    end

  end

  context  "POST" do
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

end
