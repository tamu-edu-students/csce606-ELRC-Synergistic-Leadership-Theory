# frozen_string_literal: true

Given('the application is running') do
  visit root_path
end

When('I attempt to connect to the database') do
  ActiveRecord::Base.connection
  @connection_success = true
rescue StandardError => e
  @connection_success = false
  @error_message = e.error_message
end

Then('I should receive a successful connection') do
  expect(@connection_success).to be_truthy
end
