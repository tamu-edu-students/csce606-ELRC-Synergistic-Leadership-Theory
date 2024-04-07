# spec/factories/survey_profiles.rb
FactoryBot.define do
    factory :survey_profile do
      user_id { SecureRandom.uuid } # Generates a unique user ID as a string; adjust if your user_id format is different
      first_name { 'John' }
      last_name { 'Doe' }
      campus_name { 'Main' }
      district_name { 'District' }
    end
  end
  