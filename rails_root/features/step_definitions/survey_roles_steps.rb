Given('I am on the survey profile form page') do
  visit new_survey_profile_path # Adjust path as per your routes
end

Then('the following roles should be available in the {string} dropdown:') do |_dropdown_label, table|
    roles = table.raw.flatten
  
    # Debugging: Check the page content
    puts page.body
  
    # Attempt different selectors
    expect(page).to have_selector('#survey_profile_role', visible: true)
  
    dropdown = find('#survey_profile_role') # Use ID selector
    
    # Get all option texts
    options = dropdown.all('option').map(&:text)
    
    # Verify the roles
    expect(options).to include(*roles)
  end
  
When('I select {string} from the {string} dropdown') do |role, dropdown_label|
  select role, from: dropdown_label
end

When('I fill in {string} with {string}') do |field_label, value|
  fill_in field_label, with: value
end

When('I click the {string} button') do |button_text|
  click_button button_text
end

Then('the survey profile should be saved with the role {string}') do |role|
  survey_profile = SurveyProfile.last # Adjust if necessary
  expect(survey_profile.role).to eq(role)
end
