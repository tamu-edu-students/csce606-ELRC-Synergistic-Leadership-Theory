# frozen_string_literal: true

# Analysis Result Presentation & Data Submission
Given('I have completed the survey with valid inputs') do
  @user_id = 1
  SurveyProfile.create(user_id: @user_id)
  @attributes = {}
  SurveyResponse.column_names.each do |name|
    @attributes[name] = nil unless %w[id created_at updated_at user_id].include? name
  end
end

# Analysis Result Presentation & Data Submission
When('I try to submit the form') do
  visit new_survey_response_path
  fill_in 'survey_response_user_id', with: @user_id
  @questions = SurveyQuestion.all
  @questions.each do |question|
    choose "survey_response_#{question.id}_1"
  end
  click_button 'commit'
end

# Initial UI Design & Theory Exploration
Given('I am on the site') do
  visit root_path
end

# Analysis Result Presentation & Data Models
Given('questions exist') do
  SurveyQuestion.create(text: 'What is your favorite color?', section: 1)
end

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
    @survey_profiles_attributes[name] = 10 if name != 'created_at' && name != 'updated_at'
  end
  @survey_responses_attributes = {}
  SurveyQuestion.all.each do |question|
    @survey_responses_attributes[question.id.to_s] = 1
  end
  @survey_responses_attributes['user_id'] = 10
end
