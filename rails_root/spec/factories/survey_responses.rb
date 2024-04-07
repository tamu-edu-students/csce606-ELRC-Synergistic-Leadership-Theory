# frozen_string_literal: true

# spec/factories/survey_responses.rb
FactoryBot.define do
  factory :survey_response do
    share_code { SecureRandom.hex(3) } # Generates a random share code
    association :profile, factory: :survey_profile
  end
end
