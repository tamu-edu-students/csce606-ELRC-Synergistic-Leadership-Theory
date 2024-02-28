# frozen_string_literal: true

class SurveyProfile < ApplicationRecord
    has_many :responses,
        foreign_key: :profile_id,
        class_name: "SurveyResponse",
        dependent: :destroy
end
