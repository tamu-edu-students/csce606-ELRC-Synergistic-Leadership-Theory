# frozen_string_literal: true

# Step definition for navigating to the homepage
Given('I am on the homepage') do
  visit root_path
  expect(page).to have_current_path(root_path) # Ensure the user is on the homepage
end

Given('I have logged in as a {string}') do |role|
  # Create a user with the specified role (principal, teacher, superintendent)
  @user = FactoryBot.create(:survey_profile, role:)
  allow_any_instance_of(ApplicationController).to receive(:current_user_id).and_return(@user.user_id)
end

Then('I should see {string} in the header') do |link_text|
  # Check that the Admin Dashboard link is present
  expect(page).to have_link(link_text)
end

When('I click on {string}') do |link_text|
  # Click the Admin Dashboard link
  click_link(link_text)
end

Then('I should be on the Admin Dashboard page') do
  # Verify that the user is redirected to the Admin Dashboard page
  expect(current_path).to eq(admin_dashboard_path)
  expect(page).to have_content('Admin Dashboard')
end
