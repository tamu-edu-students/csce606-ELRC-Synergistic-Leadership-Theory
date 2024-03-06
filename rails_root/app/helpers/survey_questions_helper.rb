# frozen_string_literal: true

# This is the helper for the SurveyQuestionsController
module SurveyQuestionsHelper
  # survey question helper functions
  # returns the question text
  def question_text(question)
    question.text
  end
end
