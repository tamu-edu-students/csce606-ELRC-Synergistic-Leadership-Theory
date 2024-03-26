require 'rails_helper'

RSpec.describe 'Auth0s', type: :request do
  before do
    mock_auth
  end

  describe 'GET /callback' do
    it 'returns http success' do
      get '/auth/auth0/callback'
      expect(response).to redirect_to(new_survey_profile_path)
    end
  end

  describe 'GET /failure' do
    it 'returns http success' do
      get '/auth/failure'
      expect(response).to have_http_status(406)
    end
  end

  describe 'GET /logout' do
    it 'returns http success' do
      get '/auth/logout'
      expect(response).to have_http_status(:redirect)
    end
  end
end
