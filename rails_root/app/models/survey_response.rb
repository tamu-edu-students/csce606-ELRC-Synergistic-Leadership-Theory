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
    profile = find_profile(user_id)

    # Use provided share_code if exists, else generate a new one
    share_code = generate_share_code(params)

    # FIXME: Handle share code already existing
    survey_response = create_survey_response(profile, share_code)

    return survey_response if params.nil?

    create_survey_answers(params, survey_response)
    survey_response
  rescue ActiveRecord::RecordNotFound
    logger.info 'Survey profile not found!'
    nil
  end

  def self.find_profile(user_id)
    SurveyProfile.where(user_id:).first!
  end

  def self.generate_share_code(params)
    params.nil? ? SecureRandom.hex(3) : params[:share_code] || SecureRandom.hex(3)
  end

  def self.create_survey_response(profile, share_code)
    SurveyResponse.create(profile:, share_code:)
  end

  def self.create_survey_answers(params, survey_response)
    params.each do |key, choice|
      begin
        question = SurveyQuestion.find key
      rescue ActiveRecord::RecordNotFound
        next
      end
      SurveyAnswer.create(choice:, question:, response: survey_response)
    end
  end

  def update_from_params(user_id, params)
    # FIXME: When we look up things and fail, we should use more descriptive exceptions instead of ActiveRecord::RecordNotFound

    SurveyProfile.where(user_id:).first!

    return if params.nil?

    params.each do |key, choice|
      begin
        question = SurveyQuestion.find key
      rescue ActiveRecord::RecordNotFound
        next
      end

      answer = SurveyAnswer.where(question:, response: self).first!
      answer.update(choice:)
    end
  end

  # TODO: Create a new function that either updates existing SurveyAnswers or adds new SurveyAnswers if they do not exist
  def add_from_params(user_id, params)
    SurveyProfile.where(user_id:).first!
    return if params.nil?

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
        answer.update(choice:)
      end
    end
  end
end
