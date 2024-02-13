require 'rails_helper'

RSpec.describe "survey_responses/new", type: :view do
  before(:each) do
    assign(:survey_response, SurveyResponse.new(
      user_id: 1,
      leads_by_example: 1,
      ability_to_juggle: 1,
      communicator: 1,
      lifelong_learner: 1,
      high_expectations: 1,
      cooperative: 1,
      empathetic: 1,
      people_oriented: 1
    ))
  end

  it "renders new survey_response form" do
    render

    assert_select "form[action=?][method=?]", survey_responses_path, "post" do

      assert_select "input[name=?]", "survey_response[user_id]"

      assert_select "input[name=?]", "survey_response[leads_by_example]"

      assert_select "input[name=?]", "survey_response[ability_to_juggle]"

      assert_select "input[name=?]", "survey_response[communicator]"

      assert_select "input[name=?]", "survey_response[lifelong_learner]"

      assert_select "input[name=?]", "survey_response[high_expectations]"

      assert_select "input[name=?]", "survey_response[cooperative]"

      assert_select "input[name=?]", "survey_response[empathetic]"

      assert_select "input[name=?]", "survey_response[people_oriented]"
    end
  end
end
