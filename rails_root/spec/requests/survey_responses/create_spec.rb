# frozen_string_literal: true

# spec/requests/survey_responses/create_spec.rb
require 'rails_helper'

RSpec.describe 'GET /create/:id', type: :request do # rubocop:disable Metrics/BlockLength
  let(:survey_profile) { FactoryBot.create(:survey_profile) }
  let(:survey_response) { FactoryBot.create(:survey_response) }
  let(:survey_answer) { FactoryBot.create(:survey_answer) }
  let(:survey_question) { FactoryBot.create(:survey_question) }
  let(:create_response_attr) do
    {
      survey_question.id => 2
    }
  end

  context 'with valid parameters' do
    before do
      allow_any_instance_of(SurveyResponsesController).to receive(:session) { { page_number: 2 } }
      allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(survey_profile.user_id)
    end

    %w[Next Save Previous Submit].each do |action|
      it "creates a new SurveyResponse when click #{action}" do
        expect do
          post survey_responses_path, params: { survey_response: create_response_attr, commit: action }
        end.to change(SurveyResponse, :count).by(1)
      end

      it "redirects to the appropriate page when click #{action}" do
        post survey_responses_path, params: { survey_response: create_response_attr, commit: action }
        redirect_path = action == 'Submit' ? survey_response_path(SurveyResponse.last) : edit_survey_response_path(SurveyResponse.last)
        expect(response).to redirect_to(redirect_path)
      end
    end

    it 'updates the requested survey_response answers' do
      my_question = survey_question
      post survey_responses_path, params: { survey_response: { my_question.id => 2 } }
      answer = SurveyAnswer.where(question: my_question, response: SurveyResponse.last).first
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
      allow_any_instance_of(SurveyResponsesController).to receive(:session) { { page_number: 2 } }
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
