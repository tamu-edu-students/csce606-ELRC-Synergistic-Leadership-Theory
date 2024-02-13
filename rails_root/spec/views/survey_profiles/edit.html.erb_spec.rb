require 'rails_helper'

RSpec.describe "survey_profiles/edit", type: :view do
  let(:survey_profile) {
    SurveyProfile.create!(
      user_id: 1,
      first_name: "MyString",
      last_name: "MyString",
      campus_name: "MyString",
      district_name: "MyString"
    )
  }

  before(:each) do
    assign(:survey_profile, survey_profile)
  end

  it "renders the edit survey_profile form" do
    render

    assert_select "form[action=?][method=?]", survey_profile_path(survey_profile), "post" do

      assert_select "input[name=?]", "survey_profile[user_id]"

      assert_select "input[name=?]", "survey_profile[first_name]"

      assert_select "input[name=?]", "survey_profile[last_name]"

      assert_select "input[name=?]", "survey_profile[campus_name]"

      assert_select "input[name=?]", "survey_profile[district_name]"
    end
  end
end
