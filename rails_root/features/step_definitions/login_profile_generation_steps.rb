  # frozen_string_literal: true
  # rubocop:disable all

require 'webmock/cucumber'

Given('I am logged in') do
  # Stub the Auth0 /authorize request

  # No route matches [GET] "/authorize" (ActionController::RoutingError)
end

Then('I see that my session variable {string} is populated') do |_string|
  # check that the session variable :userinfo is not empty or nil

  expect(page).to have_content('John Doe')
end

Given('that I am on the homepage') do
  visit root_path
  expect(page).to have_current_path(root_path)
end

Given('I try to login') do
  # expect to be on home page and see the login button
  expect(page).to have_content('Login')
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({ provider: 'auth0',
                                                               uid: 'google-oauth2|100507718411999601151',
                                                               info: {
                                                                 name: 'John Doe',
                                                                 nickname: 'JohntDoe',
                                                                 email: nil,
                                                                 image: 'https://lh3.googleusercontent.com/a/ACg8ocKu35mWhT-SFKeIcdUqWE-L3MqSUHtKTZYNH8cA1lC98oE=s96-c'
                                                               },
                                                               credentials: {
                                                                 token: 'eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiaXNzIjoiaHR0cHM6Ly9kZXYtemNmdWNrM3hnN3c1djZzYS51cy5hdXRoMC5jb20vIn0..H0PuCkDtR_V2yeJT.r6XP3TPa2Bho1wmCsE0YdGkIBciyKOPR_3K4iZvDWLmynB5mYfRwr_gJ4ZX0E9aUpRAboJ4R9VpKYySlhIgw6RC_3UhGjEgciJumb_yqbGZJfG3OQ86GEq-iCgJJgnLGB1x-q7OykkFD-NvcL-ezhbfc8khAZJfHypupFEVIneTs9Jdi4Wp5jJdsmQ6Y_-O5pACQcp5WhpQ42-Jz_mbL_f-ogs5rngRjRmmujDNgwzIQvSwYLo6yxc1C71IoDAX1PwbZVImu_jttICuUJV1GnftNvvVwb4CLQCNaEjJ386qoNTRbN6m1MjcyAuPKa3DBKmgNGNSykTD2ZZGtPwfp5Xg.lEoIk0uUzvfB97t9qLxJNQ',
                                                                 expires_at: 1_711_507_739,
                                                                 expires: true,
                                                                 id_token: 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlpmZjNwUk9SWU83WGlwcVNLcFl2cCJ9.eyJnaXZlbl9uYW1lIjoiSmFjb2IiLCJmYW1pbHlfbmFtZSI6Ik1hdGhlcyIsIm5pY2tuYW1lIjoiamFjb2J0bWF0aGVzIiwibmFtZSI6IkphY29iIE1hdGhlcyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NLdTM1bVdoVC1TRktlSWNkVXFXRS1MM01xU1VIdEtUWllOSDhjQTFsQzk4b0U9czk2LWMiLCJsb2NhbGUiOiJlbiIsInVwZGF0ZWRfYXQiOiIyMDI0LTAzLTI2VDAyOjQ4OjU4Ljk3NVoiLCJpc3MiOiJodHRwczovL2Rldi16Y2Z1Y2szeGc3dzV2NnNhLnVzLmF1dGgwLmNvbS8iLCJhdWQiOiI0bFQwM2w1R1FudlhJOFhBVUtBdGZMeEROVUJUd2tsQSIsImlhdCI6MTcxMTQyMTMzOSwiZXhwIjoxNzExNDU3MzM5LCJzdWIiOiJnb29nbGUtb2F1dGgyfDEwMDUwNzcxODQxMTk5OTYwMTE1MSIsInNpZCI6ImIxdjFjcmJYdlR1dDVBbUJYNVUtRFcwVVVwZUhiQU5EIiwibm9uY2UiOiJlMjU3OGFhYmFjYjhkNmIyMDFjMDZmMTY1MTQ2YzZmYSJ9.YMYTRfNWr2FSpB5UU1cn6zqXakiYuOmCkitasZcWbDVRdWiOOFasJ9fdGx19e3H-c6KliHKdUL6R4aIglf16Y_NN8YeR5SpsGz8o8adSHGXhO_O96hV0LW-D-Hx1GRzP95c0phdQ6Vgom-ql-DL2p2agmdgwIxuN4DNmQitX3Nndtlbky5vTzw9GNuCQrQx5pijELlMXN6bbVXyGlDcPxNyA0a3DCGbdqA-4TqdCa8eOmdAmXYCgvKq3EJO7c6X9KnLHPWEGHhOxraGy7uTAv64EkoreGffa73YueDNlbIcV4uDWlQ1SjOLParvojmxpjo8DnTB8N8jWNPGsoziymA',
                                                                 token_type: 'Bearer',
                                                                 refresh_token: nil
                                                               },
                                                               extra: {
                                                                 raw_info: {
                                                                   given_name: 'John',
                                                                   family_name: 'Doe',
                                                                   nickname: 'JohntDoe',
                                                                   name: 'John Doe',
                                                                   picture: 'https://lh3.googleusercontent.com/a/ACg8ocKu35mWhT-SFKeIcdUqWE-L3MqSUHtKTZYNH8cA1lC98oE=s96-c',
                                                                   locale: 'en',
                                                                   updated_at: '2024-03-26T02:48:58.975Z',
                                                                   iss: 'https://dev-zcfuck3xg7w5v6sa.us.auth0.com/',
                                                                   aud: '4lT03l5GQnvXI8XAUKAtfLxDNUBTwklA',
                                                                   iat: 1_711_421_339,
                                                                   exp: 1_711_457_339,
                                                                   sub: 'google-oauth2|100507718411999601151',
                                                                   sid: 'b1v1crbXvTut5AmBX5U-DW0UUpeHbAND',
                                                                   nonce: 'e2578aabacb8d6b201c06f165146c6fa'
                                                                 }
                                                               } })

  # visit callback url
  visit '/auth/auth0/callback'
end

Given('I have never created a survey profile') do
  profile = SurveyProfile.find_by_user_id('google-oauth2|100507718411999601151')
  expect(profile).to be_nil
end

Then('I am redirected to the create survey profile page') do
  expect(page).to have_current_path(new_survey_profile_path)
end

Then('I fill in my first and last name and district name and campus name and organization role and click create') do
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Doe'
  fill_in 'Campus name', with: 'Joe Campus'
  fill_in 'District name', with: 'Joe District'
  select 'Principal', from: 'Role'
  click_button 'Create Survey profile'
end

Then('I am redirected to the home page') do
  expect(page).to have_current_path(root_path)
end

Given('I have created a survey profile previously') do
  SurveyProfile.create(user_id: 'google-oauth2|100507718411999601151', first_name: 'John', last_name: 'Doe', campus_name: 'Joe Campus', district_name: 'Joe District')
end

Then('I am greeted with a welcome message') do
  expect(page).to have_content('John Doe - Welcome to Our Rails App')
end

Then('a survey profile is created') do
  profile = SurveyProfile.find_by_user_id('google-oauth2|100507718411999601151')
  expect(profile).not_to be_nil
end
#rubocop enable all