# frozen_string_literal: true

# This is the model for the SurveyResponse
class SurveyResponse < ApplicationRecord
  has_many :answers,
           foreign_key: :response_id,
           class_name: 'SurveyAnswer',
           dependent: :delete_all

  validates_associated :answers

  has_many :questions,
           class_name: 'SurveyQuestion',
           through: :answers

  belongs_to :profile,
             class_name: 'SurveyProfile'

  has_many :invitations

  def self.create_from_params(params)
    # FIXME: When we look up things and fail, we should use more descriptive exceptions instead of ActiveRecord::RecordNotFound
    profile = SurveyProfile.where(user_id: params[:user_id]).first!

    # FIXME: Handle share code already existing
    survey_response = SurveyResponse.new profile:, share_code: SecureRandom.hex(3)

    params.each do |key, choice|
      next if key == 'user_id'

      question = SurveyQuestion.find key
      SurveyAnswer.create choice:, question:, response: survey_response
    end

    survey_response
  end

  def update_from_params(params)
    # FIXME: When we look up things and fail, we should use more descriptive exceptions instead of ActiveRecord::RecordNotFound
    print self

    params.each do |key, choice|
      if key == 'user_id'
        profile = SurveyProfile.where(user_id: params[:user_id]).first!
        update profile:
      else
        question = SurveyQuestion.find key
        answer = SurveyAnswer.where(question:, response: self).first!

        answer.update choice:
      end
    end
  end
end
