# frozen_string_literal: true

class SurveyResponse < ApplicationRecord
    has_many :answers,
        foreign_key: :response_id,
        class_name: "SurveyAnswer",
        dependent: :delete_all

    belongs_to :profile,
        class_name: "SurveyProfile"
end
