# frozen_string_literal: true

class SurveyProfile < ApplicationRecord
    has_many :SurveyResponse
end
