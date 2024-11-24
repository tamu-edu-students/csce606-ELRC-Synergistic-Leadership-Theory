# frozen_string_literal: true

Then('I fill in my information as a principal') do
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Doe'
  fill_in 'Campus name', with: 'Joe Campus'
  fill_in 'District name', with: 'Joe District'
  select 'Principal', from: 'Role'
  click_button 'Create Survey profile'
end

Then('a survey profile is created for me as a principal') do
  profile = SurveyProfile.find_by_user_id('google-oauth2|100507718411999601151')
  expect(profile.role).to eq('Principal')
  expect(profile).not_to be_nil
end

Then('I am logged in as a principal') do
  expect(page).to have_content('Welcome John Doe')
  expect(page).to have_content('Role Principal')
end

When('I navigate to the survey page') do
  visit new_survey_response_path
end

Then('I should see the survey questions specific to the principal') do
  expect(page).to have_content('To what extent do you agree the following behaviors reflect your personal leadership behaviors')
end

Then('I fill in my information as a supervisee') do
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Doe'
  fill_in 'Campus name', with: 'Joe Campus'
  fill_in 'District name', with: 'Joe District'
  select 'Supervisee', from: 'Role'
  click_button 'Create Survey profile'
end

Then('a survey profile is created for me as a supervisee') do
  profile = SurveyProfile.find_by_user_id('google-oauth2|100507718411999601151')
  expect(profile.role).to eq('Supervisee')
  expect(profile).not_to be_nil
end

Then('I am logged in as a supervisee') do
  expect(page).to have_content('Welcome John Doe')
  expect(page).to have_content('Role Supervisee')
end

Then('I should see the survey questions specific to the supervisee') do
  expect(page).to have_content("To what extent do you agree the following behaviors reflect your principal's leadership behaviors")
end

Then('I fill in my information as a supervisor') do
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Doe'
  fill_in 'Campus name', with: 'Joe Campus'
  fill_in 'District name', with: 'Joe District'
  select 'Supervisor', from: 'Role'
  click_button 'Create Survey profile'
end

Then('a survey profile is created for me as a supervisor') do
  profile = SurveyProfile.find_by_user_id('google-oauth2|100507718411999601151')
  expect(profile.role).to eq('Supervisor')
  expect(profile).not_to be_nil
end

Then('I am logged in as a supervisor') do
  expect(page).to have_content('Welcome John Doe')
  expect(page).to have_content('Role Supervisor')
end

Then('I should see the survey questions specific to the supervisor') do
  expect(page).to have_content("To what extent do you agree the following behaviors reflect your principal's leadership behaviors")
end
