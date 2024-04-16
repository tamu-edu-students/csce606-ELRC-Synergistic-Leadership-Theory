# frozen_string_literal: true

# spec/requests/survey_responses/update_spec.rb
require 'rails_helper'

RSpec.describe 'GET /update/:id', type: :request do # rubocop:disable Metrics/BlockLength
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
      my_answer = survey_answer
      patch survey_response_url(my_answer.response), params: { survey_response: { my_answer.question.id => 2 } }
      expect(response).to redirect_to(root_url)
    end
  end

  context 'user profile not exist' do
    before do
      allow_any_instance_of(SurveyResponsesController).to receive(:session) { { user_id: 99, page_number: 2 } }
      allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return(99)
    end
    it 'redirects to the root page' do
      my_answer = survey_answer
      patch survey_response_url(my_answer.response), params: { survey_response: { my_answer.question.id => 2 } }
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
