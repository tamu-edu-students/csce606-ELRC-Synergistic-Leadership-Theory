# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  render_views

  describe 'POST #create' do
    let(:profile) { SurveyProfile.create!(user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District') }
    let(:survey_response) do
      sr = SurveyResponse.create(share_code: 'SHARECODE', profile:)
      puts sr.errors.full_messages if sr.errors.any?
      sr
    end

    it 'creates a new invitation' do
      expect do
        post :create, params: { survey_response_share_code: survey_response.share_code }
      end.to change(Invitation, :count).by(1)
    end

    it 'redirects to the survey response' do
      post :create, params: { survey_response_share_code: survey_response.share_code }
      expect(response).to redirect_to(survey_response_path(survey_response))
    end

    it 'sets a flash message' do
      post :create, params: { survey_response_share_code: survey_response.share_code }
      expect(flash[:warning]).to match(/Invitation link created:/)
    end
  end

  describe 'GET #show' do
    let(:profile) { SurveyProfile.create!(user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District') }
    let(:survey_response) do
      sr = SurveyResponse.create(share_code: 'SHARECODE', profile:)
      puts sr.errors.full_messages if sr.errors.any?
      sr
    end
    let(:invitation) { Invitation.create!(parent_response_id: survey_response.id, created_by: profile, visited: false, last_sent: Time.now) }

    before do
      get :show, params: { token: invitation.token }
    end

    it 'assigns the requested invitation to @invitation' do
      expect(@controller.instance_variable_get('@invitation')).to eq(invitation)
    end

    it 'sets visited to true' do
      invitation.reload
      expect(invitation.visited).to be true
    end

    it 'renders the :show template' do
      expect(response.body).to include "You've been invited to take a survey"
      expect(response.body).to include 'Take the Survey'
    end

    context 'when the invitation does not exist' do
      it 'redirects to the root path with an error message' do
        get :show, params: { token: 'nonexistent_token' }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('This invitation link has expired.')
      end
    end

    context 'when the invitation has already been visited' do
      let(:visited_invitation) { Invitation.create!(parent_response_id: survey_response.id, created_by: profile, visited: true, last_sent: Time.now) }

      it 'redirects to the root path with an error message' do
        get :show, params: { token: visited_invitation.token }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('This invitation link has expired.')
      end
    end
  end
end
