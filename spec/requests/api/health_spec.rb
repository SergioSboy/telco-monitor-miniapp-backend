# frozen_string_literal: true

require 'rails_helper'

describe 'apihealth', type: :request do
  let(:http_method) { :get }
  let(:make_request) { send(http_method, '/api/health') }

  context 'когда сервис доступен' do
    it 'status ok' do
      make_request
      expect(response).to have_http_status(200)
    end
  end
end
