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

Given('I have created survey response for user {string}') do |id|
  @user_id = id
  survey_profile = SurveyProfile.find_or_create_by(user_id: @user_id)
  SurveyResponse.create!(profile: survey_profile, share_code: "debug#{survey_profile.user_id}")
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
  @model_attributes = {}
  @model_attributes['SurveyProfile'] = {}
  SurveyProfile.column_names.each do |name|
    @model_attributes['SurveyProfile'][name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end

  @model_attributes['SurveyResponse'] = {}
  SurveyResponse.column_names.each do |name|
    @model_attributes['SurveyResponse'][name] = nil if name != 'id' && name != 'created_at' && name != 'updated_at'
  end
end

Given('I have a set of valid attributes') do
  @model_attributes = {}

  @model_attributes['SurveyProfile'] = {}
  SurveyProfile.column_names.each do |name|
    @model_attributes['SurveyProfile'][name] = 10 if name != 'created_at' && name != 'updated_at'
  end

  @model_attributes['SurveyResponse'] = {}
  @model_attributes['SurveyResponse']['profile_id'] = 10
end

Given('survey profiles exist') do
  SurveyProfile.create!(user_id: 1)
  SurveyProfile.create!(user_id: 2)
end
