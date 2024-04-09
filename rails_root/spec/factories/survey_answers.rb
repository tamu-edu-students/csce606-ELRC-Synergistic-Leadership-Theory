# frozen_string_literal: true

# spec/factories/survey_answer.rb
FactoryBot.define do
  factory :survey_answer do
    choice { 0 }
    association :question, factory: :survey_question
    association :response, factory: :survey_response
  end
end
