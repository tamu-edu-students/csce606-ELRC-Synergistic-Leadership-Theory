# frozen_string_literal: true

When('I visit about page') do
  visit about_path
end

Then('I can read about theory information') do
  expect(page).to have_content('The Synergistic Leadership Theory (SLT) was developed')
end

Then('I can see the tetrahedron') do
  expect(page).to have_css('img')
end
