# frozen_string_literal: true

When('I try to create model instances') do
  post survey_profiles_url, survey_profile: @survey_profiles_attributes
  post survey_responses_url, survey_response: @survey_responses_attributes
end

Then('the model was not created') do
  expect(SurveyProfile.last).to be_nil
  expect(SurveyResponse.last).to be_nil
end

Then('the model was created') do
  expect(SurveyProfile.last.user_id).to eq(10)
  expect(SurveyResponse.last).to be_truthy
end
