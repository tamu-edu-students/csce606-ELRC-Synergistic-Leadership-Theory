# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do # rubocop:disable Metrics/BlockLength
  render_views

  describe 'POST #create' do
    let(:profile) { SurveyProfile.create!(user_id: 1, first_name: 'Seymour', last_name: 'Skinner', campus_name: 'Springfield Elementary', district_name: 'Springfield') }
    let(:survey_response) do
      sr = SurveyResponse.create(share_code: 'SHARECODE', profile:)
      puts sr.errors.full_messages if sr.errors.any?
      sr
    end

    context 'when a survey response exists' do
      before do
        post :create, params: { parent_survey_response_id: survey_response.id }
      end

      it 'creates a new invitation' do
        expect(assigns(:invitation)).to be_a(Invitation)
        expect(assigns(:invitation)).to be_persisted
      end

      it 'sets the invitation\'s sharecode to the response\'s sharecode' do
        expect(assigns(:invitation).parent_response.share_code).to eq(survey_response.share_code)
      end

      it 'sets the invitation\'s parent_response_id to the response\'s id' do
        expect(assigns(:invitation).parent_response_id).to eq(survey_response.id)
      end
    end
  end

  describe 'GET #show' do
    let(:profile) { SurveyProfile.create!(user_id: 1, first_name: 'Seymour', last_name: 'Skinner', campus_name: 'Springfield Elementary', district_name: 'Springfield') }
    let(:survey_response) do
      sr = SurveyResponse.create(share_code: 'SHARECODE', profile:)
      puts sr.errors.full_messages if sr.errors.any?
      sr
    end
    let(:invitation) { Invitation.create!(parent_response_id: survey_response.id, visited: false, last_sent: Time.now) }

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
        expect(response).to redirect_to(not_found_invitations_path)
      end
    end

    context 'when the invitation has already been visited' do
      let(:visited_invitation) { Invitation.create!(parent_response_id: survey_response.id, visited: true, last_sent: Time.now) }

      it 'redirects to the root path with an error message' do
        get :show, params: { token: visited_invitation.token }
        expect(response).to redirect_to(not_found_invitations_path)
      end
    end
  end

  describe 'GET #invitation_created' do
    context 'when invitation is not found' do
      it 'redirects to not_found' do
        get :invitation_created, params: { token: 'nonexistent_token' }
        expect(response).to redirect_to(not_found_invitations_path)
      end
    end
  end
end
