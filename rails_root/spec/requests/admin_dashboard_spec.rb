# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Dashboard Access', type: :request do
  # Create a user with the principal role (you can change this to other roles if needed)
  let(:user) { FactoryBot.create(:survey_profile, role: 'Teacher') }

  before do
    allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(user.user_id)
  end

  describe 'GET / (Homepage)' do
    it 'displays the Admin Dashboard link in the header' do
      # Visit the homepage
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Admin Dashboard')
    end
  end

  describe 'GET /admin_dashboard' do
    it 'redirects to the Admin Dashboard page when clicked' do
      # Visit the Admin Dashboard page
      get admin_dashboard_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Admin Dashboard')
    end
  end
end
