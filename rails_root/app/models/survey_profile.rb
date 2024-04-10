# frozen_string_literal: true

# This is the model for the SurveyProfile
class SurveyProfile < ApplicationRecord
  enum role: {
    principal: 0,
    teacher: 1,
    superintendent: 2
  }
  has_many :responses,
           foreign_key: :profile_id,
           class_name: 'SurveyResponse',
           dependent: :destroy
  has_many :created_invitations, class_name: 'Invitation', foreign_key: 'created_by_id'
end
