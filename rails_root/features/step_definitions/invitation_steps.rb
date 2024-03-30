# frozen_string_literal: true

Given('I have completed the survey') do
  profile = SurveyProfile.create!(user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District')
  @survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
end

When('I create an invitation at the bottom of the response page') do
  visit survey_response_path(@survey_response)

  click_button 'Create Invitation'
end

Then('I should see a link that can be copied') do
  expect(page.body).to match(%r{Invitation link created: #{Capybara.current_host}/invitations/[a-zA-Z0-9\-_]+})
end

###

Given('an invitation link exists') do
  profile = SurveyProfile.create!(user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District')
  survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
  @invitation = Invitation.create!(parent_response: survey_response, created_by: profile, visited: false, last_sent: Time.now)
end

When('I visit the invitation link') do
  visit invitation_path(@invitation.token)
end

Then('I should see the invitation landing page') do
  expect(page).to have_current_path(invitation_path(@invitation.token))
end

Then('I should see a button to take the test') do
  if page.has_button?('Take the Survey')
    expect(page).to have_button('Take the Survey')
    form = page.find('form', text: 'Take the Survey')
    expect(form[:action]).to eq('/auth/auth0')
  else
    expect(page).to have_link('Take the Survey', href: new_survey_response_path(share_code: @invitation.parent_response.share_code))
  end
end

Then("the invitation record's visited field should be set to true") do
  @invitation.reload
  expect(@invitation.visited).to be true
end
