# frozen_string_literal: true

# Analysis Result Presentation Steps
Given('I have completed the survey with invalid inputs') do
  @user_id = nil
  @attributes = {}
  SurveyResponse.column_names.each do |name|
    @attributes[name] = nil unless %w[id created_at updated_at user_id].include? name
  end
end

Given('I have completed the survey with valid inputs') do
  @user_id = 1
  @attributes = {}
  SurveyResponse.column_names.each do |name|
    @attributes[name] = nil unless %w[id created_at updated_at user_id].include? name
  end
end

When('I try to submit the form') do
  visit new_survey_response_path
  fill_in 'survey_response_user_id', with: @user_id
  @attributes.each_key do |key|
    choose "survey_response_#{key}_0"
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
  @attributes.each_value do |_value|
    expect(page).to have_content(0)
  end
end

Then('the analysis results displays my leadership style') do
  expect(page).to have_content('Your leadership type is:')
end

# Initial UI Design Steps
Given('I am on the site') do
  visit root_path
end

When('I visit survey profile page') do
  visit new_survey_profile_path
end

Then('I can see profile form') do
  expect(page).to have_content('The questionaire has a total of 96 questions split into 4 parts:')
end

When('I visit survey form page') do
  visit new_survey_response_path
end

Then('I can see survey form') do
  expect(page).to have_content('Part 2: Leadership Behavior - Interpersonal')
end

# Development Environment Setup Steps
Given('the application is running') do
  visit root_path
end

When('I attempt to connect to the database') do
  ActiveRecord::Base.connection
  @connection_success = true
rescue StandardError => e
  @connection_success = false
  @error_message = e.error_message
end

Then('I should receive a successful connection') do
  expect(@connection_success).to be_truthy
end

# Theory Exploration Steps
When('I visit about page') do
  visit about_index_path
end

Then('I can read about theory information') do
  expect(page).to have_content('The Four Factors and the Tetrahedron')
end
