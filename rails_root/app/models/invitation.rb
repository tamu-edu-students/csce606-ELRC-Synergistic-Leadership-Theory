# frozen_string_literal: true

# User can create this invitation entity in the response page,
# once they finish their survey.
class Invitation < ApplicationRecord
  belongs_to :survey_response
  belongs_to :created_by, class_name: 'SurveyProfile', foreign_key: 'created_by_id'
end
