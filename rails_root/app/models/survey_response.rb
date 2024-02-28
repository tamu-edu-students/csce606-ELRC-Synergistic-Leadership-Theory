# frozen_string_literal: true

class SurveyResponse < ApplicationRecord
    has_many :answers, class_name: "SurveyAnswer", foreign_key: :response_id
    belongs_to :profile, class_name: "SurveyProfile"
end
