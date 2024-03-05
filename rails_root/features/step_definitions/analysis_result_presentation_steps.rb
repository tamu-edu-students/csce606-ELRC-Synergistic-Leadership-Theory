# frozen_string_literal: true

Given('I have completed the survey with invalid inputs') do
  @user_id = nil
  @attributes = {}
  SurveyResponse.column_names.each do |name|
    @attributes[name] = nil unless %w[id created_at updated_at user_id].include? name
  end
end

Then('I do not get redirected to the analysis presentation page') do
  expect(page).to have_current_path(survey_responses_path)
end

Then('I do get redirected to the analysis presentation page') do
  expect(page).to have_current_path(survey_response_path(SurveyResponse.last))
  expect(page).to have_content('Survey response was successfully created')
end
