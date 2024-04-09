# frozen_string_literal: true

# spec/factories/survey_questions.rb
FactoryBot.define do
  factory :survey_question do
    text { 'Question 1' } # Generates a unique user ID as a string; adjust if your user_id format is different
    explanation { 'Some explanation' }
    section { 1 }
  end
end
