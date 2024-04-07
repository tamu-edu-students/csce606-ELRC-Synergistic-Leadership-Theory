# frozen_string_literal: true

require 'rack_session_access/capybara'

Given('I have logged in with user {string}') do |id|
  page.set_rack_session(userinfo: { 'sub' => id })
  SurveyProfile.find_or_create_by(user_id: id)
end

Given('I have not logged in') do
  page.set_rack_session(userinfo: nil)
end
