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
  expect(page).to have_content('Role: Principal')
end

When('I navigate to the survey page') do
  visit new_survey_response_path
end

Then('I should see the survey questions specific to the principal') do
  expect(page).to have_content('To what extent do you agree the following behaviors reflect your personal leadership behaviors')
end

Then('I fill in my information as a teacher') do
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Doe'
  fill_in 'Campus name', with: 'Joe Campus'
  fill_in 'District name', with: 'Joe District'
  select 'Teacher', from: 'Role'
  click_button 'Create Survey profile'
end

Then('a survey profile is created for me as a teacher') do
  profile = SurveyProfile.find_by_user_id('google-oauth2|100507718411999601151')
  expect(profile.role).to eq('Teacher')
  expect(profile).not_to be_nil
end

Then('I am logged in as a teacher') do
  expect(page).to have_content('Welcome John Doe')
  expect(page).to have_content('Role: Teacher')
end

Then('I should see the survey questions specific to the teacher') do
  expect(page).to have_content("To what extent do you agree the following behaviors reflect your principal's leadership behaviors")
end

Then('I fill in my information as a superintendent') do
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Doe'
  fill_in 'Campus name', with: 'Joe Campus'
  fill_in 'District name', with: 'Joe District'
  select 'Superintendent', from: 'Role'
  click_button 'Create Survey profile'
end

Then('a survey profile is created for me as a superintendent') do
  profile = SurveyProfile.find_by_user_id('google-oauth2|100507718411999601151')
  expect(profile.role).to eq('Superintendent')
  expect(profile).not_to be_nil
end

Then('I am logged in as a superintendent') do
  expect(page).to have_content('Welcome John Doe')
  expect(page).to have_content('Role: Superintendent')
end

Then('I should see the survey questions specific to the superintendent') do
  expect(page).to have_content("To what extent do you agree the following behaviors reflect your principal's leadership behaviors")
end
