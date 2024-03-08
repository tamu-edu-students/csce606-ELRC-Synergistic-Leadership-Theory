# frozen_string_literal: true

Given('survey responses exist') do
  SurveyResponse.create!(profile_id: 1, share_code: '123')
  SurveyResponse.create!(profile_id: 2, share_code: '456')
end

Given('I am on the survey responses page') do
  visit survey_responses_path
end

When('I enter a unique case number in the {string}') do |_string|
  fill_in 'query', with: '123'
  click_button 'Search'
end

Then('I see a list of survey responses with that case number') do
  # expect there to be survey responses with the case number in the table of survey responses
  within 'table' do
    expect(page).to have_content('123')
  end
end

When('I enter a unique case number with no linked survey responses in the {string}') do |_string|
  fill_in 'query', with: '789'
  click_button 'Search'
end

Then("I don't see a list of survey_responses with that case number") do
  # expect there to be no survey responses with the case number in the table of survey responses
  within 'table' do
    expect(page).not_to have_content('789')
  end
end

Then('a warning is flashed') do
  # expect there to be a warning flashed
  expect(page).to have_content('No survey responses found for share code 789')
end
