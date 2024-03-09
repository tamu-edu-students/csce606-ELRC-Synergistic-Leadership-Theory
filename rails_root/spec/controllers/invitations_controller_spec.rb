# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  render_views

  describe 'GET #show' do
    let(:profile) { SurveyProfile.create!(user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District') }
    let(:survey_response) { SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id) }
    let(:invitation) { Invitation.create!(survey_response:, created_by: profile, visited: false, last_sent: Time.now) }

    before do
      get :show, params: { id: invitation.id }
    end

    it 'assigns the requested invitation to @invitation' do
      expect(@controller.instance_variable_get('@invitation')).to eq(invitation)
    end

    it 'renders the :show template' do
      # expect(response.content_type).to eq 'text/html'
      expect(response.body).to include "You've been invited to take a survey"
      expect(response.body).to include 'Take the Survey'
    end
  end
end
