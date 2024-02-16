Given('I have completed the survey with invalid inputs') do
  @attributes ||= {
    user_id: nil,
    leads_by_example: nil,
    ability_to_juggle: nil,
    communicator: nil,
    lifelong_learner: nil,
    high_expectations: nil,
    cooperative: nil,
    empathetic: nil,
    people_oriented: nil
  }
end

Given('I have completed the survey with valid inputs') do
  @attributes ||=
    {
      user_id: 100,
      leads_by_example: 1,
      ability_to_juggle: 1,
      communicator: 1,
      lifelong_learner: 1,
      high_expectations: 1,
      cooperative: 1,
      empathetic: 1,
      people_oriented: 1
    }
end

When('I try to submit the form') do
  visit new_survey_response_path
  @attributes.each do |key, value|
    fill_in 'survey_response_' + key.to_s, with: value
  end
  click_button 'commit'
end

Then('I do not get redirected to the analysis presentation page') do
  expect(page).not_to have_content('Survey response was successfully created')
end

Then('I do get redirected to the analysis presentation page') do
  expect(page).to have_current_path(survey_response_url(SurveyResponse.last))
  expect(page).to have_content('Survey response was successfully created')
end
