# frozen_string_literal: true

# User can create this invitation entity in the response page,
# once they finish their survey.
class Invitation < ApplicationRecord
  belongs_to :response, class_name: 'SurveyResponse', foreign_key: 'response_id', optional: true
  belongs_to :claimed_by, class_name: 'SurveyProfile', foreign_key: 'claimed_by_id', optional: true
  belongs_to :parent_response, class_name: 'SurveyResponse', foreign_key: 'parent_response_id'

  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
