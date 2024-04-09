# frozen_string_literal: true

Then('the analysis results displays the correct values') do
  @attributes.each_value do |_value|
    expect(page).to have_content(0)
  end
end

Then('the analysis results displays my leadership style') do
  expect(page).to have_content('Your leadership type is:')
end

Given('I have no survey profile') do
  SurveyProfile.destroy_all
end

When('I click Next button') do
  find(:button, name: 'commit', value: 'Next').click
end

When('I keep click Next button') do
  while page.has_button?('commit', value: 'Next')
    find(:button, name: 'commit', value: 'Next').click
    # Optional: Add a sleep to slow down the clicking process if necessary
    sleep 0.1
  end
end

When('I click Previous button') do
  find(:button, name: 'commit', value: 'Previous').click
end

When('I click Save button') do
  find(:button, name: 'commit', value: 'Save').click
end

When('I click Submit button') do
  find(:button, name: 'commit', value: 'Submit').click
end

Then('I should see Next button') do
  expect(page).to have_button('commit', value: 'Next')
end

Then('I should see Previous button') do
  expect(page).to have_button('commit', value: 'Previous')
end

Then('I should see Save button') do
  expect(page).to have_button('commit', value: 'Save')
end

Then('I should see Submit button') do
  expect(page).to have_button('commit', value: 'Submit')
end

Then('I should be on root page') do
  expect(page).to have_current_path(root_url, url: true)
end

When('I I fill in the form with Disagree') do
  @questions = SurveyQuestion.all
  @questions.limit(10).each do |question|
    choose "survey_response_#{question.id}_1"
  end
end
