# spec/requests/survey_responses_spec.rb
require 'rails_helper'

RSpec.describe 'SurveyResponses', type: :request do
  let(:survey_profile) { FactoryBot.create(:survey_profile) }
  let(:survey_response) { FactoryBot.create(:survey_response) }
  let(:survey_answer) { FactoryBot.create(:survey_answer) }
  let(:create_response_attr) do
    {
      '1': 1
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get survey_responses_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show/:id' do
    # TODO: show if user id matches
    it 'renders a successful response' do
      get survey_response_url(survey_response)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    context 'user profile exist' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { { user_id: survey_profile.user_id} }
      end
      it 'returns a successful response' do
        get new_survey_response_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the new template' do
        get new_survey_response_path
        expect(response).to render_template(:new)
      end
    end

    context 'user profile not exist' do
      it 'redirects to the root page' do
        get new_survey_response_path
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { { user_id: survey_profile.user_id, page_number: 2 } }
      end

      it 'creates a new SurveyResponse when click Next' do
        expect do
          post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Next' }
        end.to change(SurveyResponse, :count).by(1)
      end

      it 'redirects to the SurveyResponse edit page when click Next' do
        post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Next' }
        expect(response).to redirect_to(edit_survey_response_path(SurveyResponse.last))
      end

      it 'creates a new SurveyResponse when click Save' do
        expect do
          post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Save' }
        end.to change(SurveyResponse, :count).by(1)
      end

      it 'redirects to the SurveyResponse edit page when click Save' do
        post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Save' }
        expect(response).to redirect_to(edit_survey_response_path(SurveyResponse.last))
      end

      it 'creates a new SurveyResponse when click Previous' do
        expect do
          post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Previous' }
        end.to change(SurveyResponse, :count).by(1)
      end

      it 'redirects to the SurveyResponse edit page when click Previous' do
        post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Previous' }
        expect(response).to redirect_to(edit_survey_response_path(SurveyResponse.last))
      end

      it 'creates a new SurveyResponse when click Submit' do
        expect do
          post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Submit' }
        end.to change(SurveyResponse, :count).by(1)
      end

      it 'redirects to the SurveyResponse show page when click Submit' do
        post survey_responses_path, params: { survey_response: create_response_attr, commit: 'Submit' }
        expect(response).to redirect_to(survey_response_path(SurveyResponse.last))
      end
    end

    context 'without user id' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { { page_number: 2 } }
      end
      it 'returns to root' do
        post survey_responses_path
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
