# frozen_string_literal: true

# This is the model for the SurveyProfile
class SurveyProfile < ApplicationRecord
  has_many :responses,
           foreign_key: :profile_id,
           class_name: 'SurveyResponse',
           dependent: :destroy
end
