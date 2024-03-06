# frozen_string_literal: true

# This is the model for the SurveyQuestion
class SurveyQuestion < ApplicationRecord
  validates :text, presence: true
end
