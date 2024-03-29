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

  def self.create_from_params(user_id, params)
    # FIXME: When we look up things and fail, we should use more descriptive exceptions instead of ActiveRecord::RecordNotFound
    begin
      profile = SurveyProfile.where(user_id: user_id).first!
      # FIXME: Handle share code already existing
      survey_response = SurveyResponse.create profile:, share_code: SecureRandom.hex(3)
      if not params.nil?
        params.each do |key, choice|
          begin
            question = SurveyQuestion.find key
          rescue ActiveRecord::RecordNotFound
            next
          end
          SurveyAnswer.create choice:, question:, response: survey_response
        end
      end
      survey_response
    rescue ActiveRecord::RecordNotFound
      logger.info "Survey profile not found!"
      return nil
    end

    # 96.times do |i|
    #   begin
    #     index = (i+1).to_s
    #     question = SurveyQuestion.find index
    #     if params[index].nil?
    #       choice = "5"
    #     else
    #       choice = params[index]
    #     end
    #     SurveyAnswer.create choice:, question:, response: survey_response
    #   end
    # end

  end

  def update_from_params(user_id, params)
    # FIXME: When we look up things and fail, we should use more descriptive exceptions instead of ActiveRecord::RecordNotFound

    profile = SurveyProfile.where(user_id: user_id).first!

    if not params.nil?
      params.each do |key, choice|
        begin
          question = SurveyQuestion.find key
        rescue ActiveRecord::RecordNotFound
          next
        end

        answer = SurveyAnswer.where(question:, response: self).first!
        answer.update choice:
      end
    end
  end
  # TODO: Create a new function that either updates existing SurveyAnswers or adds new SurveyAnswers if they do not exist
  def add_from_params(user_id, params)
    profile = SurveyProfile.where(user_id: user_id).first!
    if not params.nil?
      params.each do |key, choice|
        begin
          question = SurveyQuestion.find key
        rescue ActiveRecord::RecordNotFound
          next
        end
        answer = SurveyAnswer.where(question:, response: self).first
        if answer.nil?
          SurveyAnswer.create choice:, question:, response: self
        else
          answer = SurveyAnswer.where(question:, response: self).first!
          answer.update choice:
        end
      end
    end
  end
end
