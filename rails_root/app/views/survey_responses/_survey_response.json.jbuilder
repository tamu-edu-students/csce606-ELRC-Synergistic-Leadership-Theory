# frozen_string_literal: true

json.extract! survey_response, :id, :user_id, :leads_by_example, :ability_to_juggle, :communicator, :lifelong_learner,
              :high_expectations, :cooperative, :empathetic, :people_oriented, :created_at, :updated_at
json.url survey_response_url(survey_response, format: :json)
