# Analysis Result Presentation Steps
Given('I have completed the survey with invalid inputs') do
  @attributes = {}
  SurveyResponse.column_names.each do |name|
    @attributes[name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
end

Given('I have completed the survey with valid inputs') do
  @attributes = {}
  SurveyResponse.column_names.each do |name|
    @attributes[name] = 1 if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
end

When('I try to submit the form') do
  visit new_survey_response_path
  @attributes.each do |key, value|
    fill_in 'survey_response_' + key.to_s, with: value
  end
  click_button 'commit'
end

Then('I do not get redirected to the analysis presentation page') do
  expect(page).to have_current_path(survey_responses_path)
end

Then('I do get redirected to the analysis presentation page') do
  expect(page).to have_current_path(survey_response_url(SurveyResponse.last))
  expect(page).to have_content('Survey response was successfully created')
end

# Data Model Design Steps
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

When('I try to create model instances') do
  post survey_profiles_url, survey_profile: @survey_profiles_attributes
  post survey_responses_url, survey_response: @survey_profiles_attributes
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

Then('the model was not created') do
  expect(SurveyProfile.last).to be_nil
  expect(SurveyResponse.last).to be_nil
end

Then('the model was created') do
  expect(SurveyProfile.last.user_id).to eq(10)
  expect(SurveyResponse.last.user_id).to eq(10)
end

# Data Submission Steps
Then('the analysis results displays the correct values') do
  @attributes.each_value do |value|
    expect(page).to have_content(value)
  end
end

Then('the analysis results displays my leadership style') do
  expect(page).to have_content('Your leadership type is:')
end
