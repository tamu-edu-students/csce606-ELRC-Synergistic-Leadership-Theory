# frozen_string_literal: true

Given(/the following questions exist/) do |survey_questions_table|
  survey_questions_table.hashes.each do |question|
    SurveyQuestion.create question
  end
end

Given(/many questions exist/) do
  (0..5).each do |_|
    (0..10).each do |_|
      FactoryBot.create(:survey_question)
    end
  end
end

When('I visit survey profile page') do
  visit new_survey_profile_path
end

When('I visit new survey page') do
  visit new_survey_response_path
end

When('I visit survey responses page') do
  visit survey_responses_path
end

When('I go to survey result page {int}') do |i|
  visit survey_response_path(i)
end

When('I click New survey response') do
  click_link('New survey response')
end

Then('I can see profile form') do
  expect(page).to have_content('Input user information')
end

Then('I can see survey sections') do
  expect(page).to have_content('Part 1')
end

Then('I can see {string}') do |string|
  expect(page).to have_content(string)
end

Given('the survey profiles exist:') do |table|
  table.hashes.each do |profile|
    SurveyProfile.create profile
  end
end

Given('user {int} responses to question {string}') do |int, string|
  question = SurveyQuestion.find_by(text: string)
  profile = SurveyProfile.find_by(user_id: int)
  response = SurveyResponse.find_or_create_by!(profile:, share_code: "debug#{profile.user_id}")
  SurveyAnswer.create!(choice: 0, question:, response:)
end

When('I am on the survey responses page of user {int}') do |int|
  profile = SurveyProfile.find_by(user_id: int)
  response = SurveyResponse.find_or_create_by!(profile:, share_code: "debug#{profile.user_id}")
  puts survey_response_path(response)
  visit survey_response_path(response)
end
