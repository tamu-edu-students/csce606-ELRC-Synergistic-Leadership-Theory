# frozen_string_literal: true

# Analysis Result Presentation & Data Submission
Given('I have completed the survey with valid inputs') do
  @user_id = 1
  @attributes = {}
  SurveyResponse.column_names.each do |name|
    @attributes[name] = nil unless %w[id created_at updated_at user_id].include? name
  end
end

# Analysis Result Presentation & Data Submission
When('I try to submit the form') do
  visit new_survey_response_path
  fill_in 'survey_response_user_id', with: @user_id
  @attributes.each_key do |key|
    choose "survey_response_#{key}_0"
  end
  click_button 'commit'
end

# Initial UI Design & Theory Exploration
Given('I am on the site') do
  visit root_path
end
