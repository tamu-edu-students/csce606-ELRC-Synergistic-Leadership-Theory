# frozen_string_literal: true

# This is the model for the SurveyAnswer
class SurveyAnswer < ApplicationRecord
  belongs_to :question,
             class_name: 'SurveyQuestion'

  belongs_to :response,
             class_name: 'SurveyResponse'
end
