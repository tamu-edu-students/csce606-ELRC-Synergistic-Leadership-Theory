# frozen_string_literal: true

# spec/requests/survey_responses/destroy_spec.rb
require 'rails_helper'

RSpec.describe 'GET /destroy/:id', type: :request do
  let(:survey_profile) { FactoryBot.create(:survey_profile) }
  let(:survey_response) { FactoryBot.create(:survey_response) }
  let(:survey_answer) { FactoryBot.create(:survey_answer) }
  let(:survey_question) { FactoryBot.create(:survey_question) }
  let(:create_response_attr) do
    {
      survey_question.id => 2
    }
  end

  it 'destroys the requested survey_response' do
    my_response = survey_response
    expect do
      delete survey_response_url(my_response)
    end.to change(SurveyResponse, :count).by(-1)
  end

  it 'redirects to the survey_responses list' do
    delete survey_response_url(survey_response)
    expect(response).to redirect_to(survey_responses_url)
  end
end
