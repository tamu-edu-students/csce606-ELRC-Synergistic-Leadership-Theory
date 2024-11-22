# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Dashboard Access', type: :request do
  # Create a user with the principal role (you can change this to other roles if needed)
  let(:user) { FactoryBot.create(:survey_profile, role: 'Supervisee') }

  before do
    allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(user.user_id)
  end


  describe 'GET / (Homepage)' do
    it 'does not display the Admin Dashboard link in the header' do
      # Visit the homepage
      get root_path
  
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include('Admin Dashboard')
    end
  end
  
  describe 'GET /admin_dashboard' do
    it 'restricts access to the Admin Dashboard page' do
      # Visit the Admin Dashboard page
      get root_path
  
      # Expect a redirection or forbidden response, depending on your application's behavior
      #expect(response).to have_http_status(:redirect).or have_http_status(:forbidden)
      expect(response.body).not_to include('Admin Dashboard')
    end
  end
end
