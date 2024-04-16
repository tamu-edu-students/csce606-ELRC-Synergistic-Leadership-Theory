# frozen_string_literal: true

# spec/requests/survey_responses/index_spec.rb
require 'rails_helper'

RSpec.describe 'GET /index/:id', type: :request do
  let(:survey_profile) { FactoryBot.create(:survey_profile) }
  let(:survey_response) { FactoryBot.create(:survey_response) }
  let(:survey_answer) { FactoryBot.create(:survey_answer) }
  let(:survey_question) { FactoryBot.create(:survey_question) }
  let(:create_response_attr) do
    {
      survey_question.id => 2
    }
  end

  it 'renders a successful response' do
    get survey_responses_url
    expect(response).to be_successful
  end
end
