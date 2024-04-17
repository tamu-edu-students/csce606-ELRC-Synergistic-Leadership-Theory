# frozen_string_literal: true

# require 'webmock/cucumber'

Given('I have completed the survey as user {string}') do |id|
  profile = SurveyProfile.find_or_create_by(user_id: id)
  @survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
end

When('I create an invitation at the bottom of the response page') do
  visit survey_response_path(@survey_response)

  click_button 'Create Invitation'

  # TODO: Set up Capybara for AJAX calls
  response = page.driver.post(invitations_path, {
                                parent_survey_response_id: @survey_response.id
                              })

  json_response = JSON.parse(response.body)

  invitation_link = json_response['invitation_url']

  # extract token
  @token = invitation_link.match(%r{#{Capybara.current_host}/invitations/([a-zA-Z0-9\-_]+)})[1]
  @invitation = Invitation.find_by(token: @token)
end

Then('the invitation\'s sharecode should be set to the response\'s sharecode') do
  expect(@invitation.parent_response.share_code).to eq(@survey_response.share_code)
end

And('the invitation\'s parent_response_id should be set to the response\'s id') do
  expect(@invitation.parent_response_id).to eq(@survey_response.id)
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

Given('the invitation is claimed by me') do
  profile = SurveyProfile.find_by(user_id: @my_user_id)
  @invitation.reload
  expect(@invitation.claimed_by_id).to eq(profile.id)
end

Given('the invitation is not claimed by user {string}') do |id|
  profile = SurveyProfile.find_by(user_id: id)
  @invitation.reload
  expect(@invitation.claimed_by_id).not_to eq(profile.id)
end

And('I click the button to take the test') do
  click_button 'Take the Survey'
end

Then('I should be redirected to the survey edit page') do
  @invitation.reload
  new_response_to_fill = SurveyResponse.find_by(id: @invitation.response_id)
  expect(page).to have_current_path(edit_survey_response_path(new_response_to_fill))
end

Then('I decide to use the user ID {string}') do |user_id|
  @dummy_user_id = user_id
end

Then('I decide to log in as {string}') do |full_name|
  first_name, last_name = full_name.split
  user_id = "#{first_name.downcase}.#{last_name.downcase}"

  @dummy_user_id = user_id
end

Given('I have been redirected to the external auth provider') do
  OmniAuth.config.test_mode = true
  auth_hash_json = %(
    {
      "provider": "auth0",
      "extra": {
        "raw_info": {
          "sub": "#{@dummy_user_id}"
        }
      }
    }
  )
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(JSON.parse(auth_hash_json))
end

Then('a session variable named {string} should be created') do |session_variable_name|
  expect(page.get_rack_session_key(session_variable_name)).not_to be_nil
end

Then('a session variable named {string} should not have expired') do |session_variable_name|
  expect(page.get_rack_session_key(session_variable_name)).not_to be_nil
  expect(page.get_rack_session_key('invitation')['expiration']).to be > Time.now
end

When('I return from the external auth provider {int} minutes later') do |minutes|
  # Activate time machine
  Timecop.travel(Time.now + minutes.minutes)

  # User returns from the external auth provider
  visit '/auth/auth0/callback'
end

Given('I {string}, the {string} from {string} in {string} join') do |full_name, role, school, district|
  OmniAuth.config.test_mode = true
  first_name, last_name = full_name.split
  @my_user_id = "#{first_name.downcase}.#{last_name.downcase}"
  auth_hash_json = %(
    {
      "provider": "auth0",
      "extra": {
        "raw_info": {
          "sub": "#{@my_user_id}"
        }
      }
    }
  )
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(JSON.parse(auth_hash_json))

  visit '/auth/auth0/callback'

  fill_in 'First name', with: first_name
  fill_in 'Last name', with: last_name
  fill_in 'Campus name', with: school
  fill_in 'District name', with: district
  select role, from: 'Role'
  click_button 'Create Survey profile'

  profile = SurveyProfile.find_by_user_id(@my_user_id)
  expect(profile.role).to eq(role)
  expect(profile).not_to be_nil

  expect(page).to have_current_path(root_path)
end

Then('the invitation has a non-null response object') do
  @invitation.reload
  expect(@invitation.response_id).not_to be_nil
end

Then('the response has the same sharecode as the invitation') do
  response = SurveyResponse.find_by(id: @invitation.response_id)
  expect(response.share_code).to eq(@invitation.parent_response.share_code)
end

When('I log out') do
  Capybara.reset_sessions!
  visit root_path
end

Then('I am logged in') do
  expect(page.get_rack_session_key('userinfo')).not_to be_nil
  userinfo = page.get_rack_session_key('userinfo')
  profile = SurveyProfile.find_by(user_id: userinfo['sub'])
  expect(profile).not_to be_nil
end

Then('I am not logged in') do
  userinfo = nil
  begin
    userinfo = page.get_rack_session_key('userinfo')
  rescue KeyError
    # Expected, do nothing
  end
  expect(userinfo).to be_nil
end

Then('I am logged in as {string}') do |user_id|
  expect(page.get_rack_session_key('userinfo')).not_to be_nil
  userinfo = page.get_rack_session_key('userinfo')
  expect(userinfo['sub']).to eq(user_id)
  profile = SurveyProfile.find_by(user_id: userinfo['sub'])
  expect(profile).not_to be_nil
end

Given('I have completed an originating survey') do
  profile = SurveyProfile.find_or_create_by(user_id: @my_user_id)
  @survey_response = SurveyResponse.create!(share_code: 'dial-m-for-murder', profile_id: profile.id)
end

Given('I have completed the survey') do
  @survey_response = @invitation.response
end
