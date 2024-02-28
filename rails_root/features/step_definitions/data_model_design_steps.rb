# frozen_string_literal: true

Given('I have a set of invalid attributes') do
  @survey_profiles_attributes = {}
  SurveyProfile.column_names.each do |name|
    @survey_profiles_attributes[name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
  @survey_responses_attributes = {}
  SurveyResponse.column_names.each do |name|
    @survey_responses_attributes[name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
end

Given('I have a set of valid attributes') do
  @survey_profiles_attributes = {}
  SurveyProfile.column_names.each do |name|
    @survey_profiles_attributes[name] = 10 if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
  @survey_responses_attributes = {}
  SurveyResponse.column_names.each do |name|
    @survey_responses_attributes[name] = 10 if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
end

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
  expect(SurveyResponse.last.user_id).to eq(10)
end
