# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invitations/show', type: :view do
  before do
    profile = SurveyProfile.create!(user_id: 1, first_name: 'John', last_name: 'Doe', campus_name: 'Campus', district_name: 'District')
    survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
    @invitation = assign(:invitation, Invitation.create!(parent_response_id: survey_response.id, created_by: profile, visited: false, last_sent: Time.now))
  end

  context 'when user is logged in' do
    before do
      allow(view).to receive(:session).and_return({ userinfo: { 'sub' => '123' }, invitation: { share_code: 'SHARECODE' } })
      render
    end

    it 'displays a link to take the survey' do
      expect(rendered).to have_link('Take the Survey', href: survey_path(share_code: 'SHARECODE'))
    end
  end

  context 'when user is not logged in' do
    before do
      allow(view).to receive(:session).and_return({ userinfo: nil })
      render
    end

    it 'displays a button to log in and take the survey' do
      expect(rendered).to have_selector("form[action='/auth/auth0'][method='post'] button", text: 'Take the Survey')
    end
  end
end
