require 'rails_helper'

RSpec.describe "survey_responses/show", type: :view do
  before(:each) do
    assign(:survey_response, SurveyResponse.create!(
      user_id: 2,
      leads_by_example: 3,
      ability_to_juggle: 4,
      communicator: 5,
      lifelong_learner: 6,
      high_expectations: 7,
      cooperative: 8,
      empathetic: 9,
      people_oriented: 10
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
  end
end
