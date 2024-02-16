# frozen_string_literal: true

json.extract! survey_profile, :id, :user_id, :first_name, :last_name, :campus_name, :district_name, :created_at,
              :updated_at
json.url survey_profile_url(survey_profile, format: :json)
