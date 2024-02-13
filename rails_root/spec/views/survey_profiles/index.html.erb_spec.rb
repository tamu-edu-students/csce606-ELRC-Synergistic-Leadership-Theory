require 'rails_helper'

RSpec.describe "survey_profiles/index", type: :view do
  before(:each) do
    assign(:survey_profiles, [
      SurveyProfile.create!(
        user_id: 2,
        first_name: "First Name",
        last_name: "Last Name",
        campus_name: "Campus Name",
        district_name: "District Name"
      ),
      SurveyProfile.create!(
        user_id: 2,
        first_name: "First Name",
        last_name: "Last Name",
        campus_name: "Campus Name",
        district_name: "District Name"
      )
    ])
  end

  it "renders a list of survey_profiles" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("First Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Campus Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("District Name".to_s), count: 2
  end
end
