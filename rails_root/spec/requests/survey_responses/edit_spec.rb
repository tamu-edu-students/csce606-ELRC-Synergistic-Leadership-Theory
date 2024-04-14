# frozen_string_literal: true

# spec/requests/survey_responses/edit_spec.rb
require 'rails_helper'

RSpec.describe 'GET /edit/:id', type: :request do # rubocop:disable Metrics/BlockLength
  let(:survey_profile) { FactoryBot.create(:survey_profile) }
  let(:survey_response) { FactoryBot.create(:survey_response) }
  let(:survey_answer) { FactoryBot.create(:survey_answer) }
  let(:survey_question) { FactoryBot.create(:survey_question) }
  let(:create_response_attr) do
    {
      survey_question.id => 2
    }
  end

  context 'valid response and profile exist' do
    before do
      allow_any_instance_of(SurveyResponsesController).to receive(:current_user_id).and_return('1')
    end

    it 'renders a successful response' do
      profile = FactoryBot.create(:survey_profile, user_id: 1)
      my_response = FactoryBot.create(:survey_response, profile:)
      get edit_survey_response_path(my_response)
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit template' do
      profile = FactoryBot.create(:survey_profile, user_id: 1)
      my_response = FactoryBot.create(:survey_response, profile:)
      get edit_survey_response_path(my_response)
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
