# frozen_string_literal: true

require 'webmock/cucumber'

Given('I have completed the survey as user {string}') do |id|
  profile = SurveyProfile.find_or_create_by(user_id: id)
  @survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
end

When('I create an invitation at the bottom of the response page') do
  visit survey_response_path(@survey_response)

  click_button 'Create Invitation'

  # Wait for the flash message to appear and extract the invitation token from it
  expect(page).to have_content('Invitation Created')
  @token = page.text.match(%r{Your invitation link is: #{Capybara.current_host}/invitations/([a-zA-Z0-9\-_]+)})[1]
  @invitation = Invitation.find_by(token: @token)
end

Then('the invitation\'s sharecode should be set to the response\'s sharecode') do
  expect(@invitation.parent_response.share_code).to eq(@survey_response.share_code)
end

And('the invitation\'s parent_response_id should be set to the response\'s id') do
  expect(@invitation.parent_response_id).to eq(@survey_response.id)
end

Then('I should see a link that can be copied') do
  expect(page.body).to match(%r{Your invitation link is: #{Capybara.current_host}/invitations/#{@token}})
end

###

Then('the invitation should have a unique token') do
  expect(Invitation.where(token: @invitation.token).count).to eq(1)
end

###

Given('an invitation exists') do
  profile = SurveyProfile.create!(user_id: 6974, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District')
  survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
  @invitation = Invitation.create!(parent_response: survey_response, visited: false, last_sent: Time.now)
end

When('I visit the invitation link') do
  visit invitation_path(@invitation.token)
end

Then('I should see the invitation landing page') do
  expect(page).to have_current_path(invitation_path(@invitation.token))
end

Then('I should see a button to take the test') do
    expect(page).to have_button('Take the Survey')
end

And('the invitation has expired') do
  @invitation.update(visited: true)
end

Then('I should be redirected to the not found page') do
  expect(page).to have_current_path(not_found_invitations_path)
end

Then('I should see an error message') do
  expect(page).to have_content("The invitation you're looking for could not be found.")
end

Then('the invitation should expire') do
  @invitation.reload
  expect(@invitation.visited).to be true
end

Given('the invitation is claimed by user {string}') do |id|
  profile = SurveyProfile.find_by(user_id: id)
  @invitation.reload
  expect(@invitation.claimed_by_id).to eq(profile.id)
end

And('I click the button to take the test') do
  click_button 'Take the Survey'
end

Then('I should be redirected to the survey edit page') do
  @invitation.reload
  new_response_to_fill = SurveyResponse.find_by(id: @invitation.response_id)
  expect(page).to have_current_path(edit_survey_response_path(new_response_to_fill))
end

Then('the invitation has a non-null response object') do
  @invitation.reload
  expect(@invitation.response_id).not_to be_nil
end

Then('the response has the same sharecode as the invitation') do
  response = SurveyResponse.find_by(id: @invitation.response_id)
  expect(response.share_code).to eq(@invitation.parent_response.share_code)
end

