# frozen_string_literal: true

Then('the analysis results displays the correct values') do
  @attributes.each_value do |_value|
    expect(page).to have_content(0)
  end
end

Then('the analysis results displays my leadership style') do
  expect(page).to have_content('Your leadership type is:')
end
