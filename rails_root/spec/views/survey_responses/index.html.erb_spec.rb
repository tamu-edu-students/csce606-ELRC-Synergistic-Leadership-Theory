require 'rails_helper'

RSpec.describe "survey_responses/index", type: :view do
  before(:each) do
    assign(:survey_responses, [
      SurveyResponse.create!(
        user_id: 2,
        leads_by_example: 3,
        ability_to_juggle: 4,
        communicator: 5,
        lifelong_learner: 6,
        high_expectations: 7,
        cooperative: 8,
        empathetic: 9,
        people_oriented: 10
      ),
      SurveyResponse.create!(
        user_id: 2,
        leads_by_example: 3,
        ability_to_juggle: 4,
        communicator: 5,
        lifelong_learner: 6,
        high_expectations: 7,
        cooperative: 8,
        empathetic: 9,
        people_oriented: 10
      )
    ])
  end

  it "renders a list of survey_responses" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(6.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(7.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(8.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(9.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(10.to_s), count: 2
  end
end
