# spec/requests/survey_responses_spec.rb
require 'rails_helper'

RSpec.describe 'SurveyResponses', type: :request do
  let(:survey_profile) { FactoryBot.create(:survey_profile) }
  let(:survey_response) { FactoryBot.create(:survey_response) }
  let(:survey_answer) { FactoryBot.create(:survey_answer) }
  let(:survey_question) { FactoryBot.create(:survey_question) }
  let(:create_response_attr) do
    {
      survey_question.id => 2
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get survey_responses_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show/:id' do
    context 'valid response and profile exist' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return('1')
      end
      it 'renders a successful response' do
        profile = FactoryBot.create(:survey_profile, user_id: 1)
        _response = FactoryBot.create(:survey_response, profile:)
        get survey_response_url(_response)
        expect(response).to have_http_status(:success)
      end
    end

    context 'user not logged in' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(nil)
      end

      it 'redirects to the root page' do
        get survey_response_url(survey_response)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'responses with different profile' do
      before do
        survey_response
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(99)
      end

      it 'redirects to the root page' do
        get survey_response_url(survey_response)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET /new' do
    context 'user profile exist' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(survey_profile.user_id)
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

    context 'user does not log in' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(nil)
      end
      it 'redirects to the root page' do
        get new_survey_response_path
        expect(response).to redirect_to(root_url)
      end

      context 'user profile not exist' do
        before do
          allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(99)
        end
        it 'redirects to the root page' do
          get new_survey_response_path
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end

  describe 'GET /edit' do
    context 'valid response and profile exist' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return('1')
      end

      it 'renders a successful response' do
        profile = FactoryBot.create(:survey_profile, user_id: 1)
        _response = FactoryBot.create(:survey_response, profile:)
        get edit_survey_response_path(_response)
        expect(response).to have_http_status(:success)
      end

      it 'renders the edit template' do
        profile = FactoryBot.create(:survey_profile, user_id: 1)
        _response = FactoryBot.create(:survey_response, profile:)
        get edit_survey_response_path(_response)
        expect(response).to render_template(:edit)
      end
    end

    context 'user does not log in' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(nil)
      end
      it 'redirects to the root page' do
        get edit_survey_response_path(survey_response)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'responses with different profile' do
      before do
        survey_response
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(99)
      end

      it 'redirects to the root page' do
        get edit_survey_response_path(survey_response)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { {page_number: 2 } }
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(survey_profile.user_id)
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

      
      it 'updates the requested survey_response answers' do
        _question = survey_question
        post survey_responses_path, params: { survey_response: {_question.id => 2 } }
        answer = SurveyAnswer.where(question:_question, response: SurveyResponse.last).first
        expect(answer.choice).to eq(2)
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

    context 'user profile not exist' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { { page_number: 2 } }
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(99)
      end
      it 'redirects to the root page' do
        post survey_responses_path
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        # any value in form is null
        {
          profile_id: nil,
          share_code: 1
        }
      end
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { {page_number: 2 } }
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(survey_profile.user_id)
      end

      it 'does not create a new SurveyResponse - bad attributes' do
        expect do
          post survey_responses_path, params: { survey_response: invalid_attributes }
        end.to_not change(SurveyResponse, :count)
      end

      it 'returns a failure response (i.e., to display the "new" template)' do
        post survey_responses_url, params: { survey_response: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { { page_number: 2 } }
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(survey_answer.response.profile.user_id)
      end

      it 'updates the requested survey_response answers' do
        patch survey_response_url(survey_answer.response), params: { survey_response: { survey_answer.question.id => 2 } }
        survey_answer.reload
        expect(survey_answer.choice).to eq(2)
      end

      it 'redirects to the survey_response' do
        patch survey_response_url(survey_answer.response), params: { survey_response: { survey_answer.question.id => 2 } }
        expect(response).to redirect_to(survey_answer.response)
      end
    end

    context 'without user id' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { { page_number: 2 } }
      end
      it 'returns to root' do
        _answer = survey_answer
        patch survey_response_url(_answer.response), params: { survey_response: { _answer.question.id => 2 } }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'user profile not exist' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:session) { { user_id: 99, page_number: 2 } }
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(99)
      end
      it 'redirects to the root page' do
        _answer = survey_answer
        patch survey_response_url(_answer.response), params: { survey_response: { _answer.question.id => 2 } }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'responses with different profile' do
      before do
        allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(99)
      end

      it 'redirects to the root page' do
        patch survey_response_url(survey_answer.response), params: { survey_response: { survey_answer.question.id => 2 } }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with invalid parameters' do
      it 'responds with status 422 for nil input' do
        invalid_response = {
          :user_id => nil,
          '1' => 1
        }
        patch survey_response_url(survey_response), params: { survey_response: invalid_response }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested survey_response' do
      _response = survey_response
      expect do
        delete survey_response_url(_response)
      end.to change(SurveyResponse, :count).by(-1)
    end

    it 'redirects to the survey_responses list' do
      delete survey_response_url(survey_response)
      expect(response).to redirect_to(survey_responses_url)
    end
  end
end
