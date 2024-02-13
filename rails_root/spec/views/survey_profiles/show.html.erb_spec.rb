require 'rails_helper'

RSpec.describe "survey_profiles/show", type: :view do
  before(:each) do
    assign(:survey_profile, SurveyProfile.create!(
      user_id: 2,
      first_name: "First Name",
      last_name: "Last Name",
      campus_name: "Campus Name",
      district_name: "District Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Campus Name/)
    expect(rendered).to match(/District Name/)
  end
end
