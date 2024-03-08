# frozen_string_literal: true

When('I visit survey profile page') do
  visit new_survey_profile_path
end

When('I visit survey form page') do
  visit new_survey_response_path
end

Then('I can see profile form') do
  expect(page).to have_content('The questionaire has a total of 96 questions split into 4 parts:')
end

Then('I can see survey sections') do
  ['Part 1','Part 2','Part 3','Part 4'].each do |string| 
    expect(page).to have_content(string)
  end
end

Then('I can see survey questions') do
  ['Leads by example','Cooperative','Emphasis on collegiality','Utilizes system','Emphasis on professional growth'].each do |string| 
    expect(page).to have_content(string)
  end
end
