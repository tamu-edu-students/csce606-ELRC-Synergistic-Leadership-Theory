# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invitations/show', type: :view do
  before do
    profile = SurveyProfile.create!(user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District')
    survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
    @invitation = assign(:invitation, Invitation.create!(parent_response_id: survey_response.id, created_by: profile, visited: false, last_sent: Time.now))
    render
  end

  it 'displays the inviter name' do
    expect(rendered).to match(@invitation.created_by.first_name)
    expect(rendered).to match(@invitation.created_by.last_name)
  end

  it 'displays a button to take the survey' do
    expect(rendered).to have_link('Take the Survey', href: survey_response_path(@invitation.parent_response.id))
  end
end
