# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SurveyAnswer, type: :model do
  it 'belongs to a question' do
    survey_answer = SurveyAnswer.new
    expect(survey_answer).to respond_to(:question)
  end

  it 'belongs to a response' do
    survey_answer = SurveyAnswer.new
    expect(survey_answer).to respond_to(:response)
  end
end
