# frozen_string_literal: true

# This is the model for the SurveyProfile
class SurveyProfile < ApplicationRecord
  enum role: {
    Principal: 0,
    Teacher: 1,
    Superintendent: 2
  }
  has_many :responses,
           foreign_key: :profile_id,
           class_name: 'SurveyResponse',
           dependent: :destroy

  has_many :claimed_invitations, class_name: 'Invitation', foreign_key: 'claimed_by_id'
end
