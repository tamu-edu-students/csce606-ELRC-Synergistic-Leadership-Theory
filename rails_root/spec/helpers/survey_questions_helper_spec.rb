# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SurveyQuestionsHelper, type: :helper do
  # survey question helper functions
  # returns the question text
  describe '#question_text' do
    it 'returns the question text' do
      question = SurveyQuestion.new(text: 'What is your name?')
      expect(helper.question_text(question)).to eq('What is your name?')
    end
  end
end
