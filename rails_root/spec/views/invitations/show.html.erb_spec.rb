# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invitations/show', type: :view do
  before do
    inviter_profile = SurveyProfile.create!(user_id: 1, first_name: 'Gary', last_name: 'Chalmers', campus_name: 'Springfield Elementary', district_name: 'Springfield', role: 'Superintendent')
    invitee_profile = SurveyProfile.create!(user_id: 2, first_name: 'Seymour', last_name: 'Skinner', campus_name: 'Springfield Elementary', district_name: 'Springfield', role: 'Principal')
    parent_survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: inviter_profile.id)

    @invitation = assign(:invitation, Invitation.create!(parent_response_id: parent_survey_response.id, visited: false, last_sent: Time.now))
    sharecode_from_invitation = @invitation.parent_response.share_code
    @new_response_to_fill = SurveyResponse.create(profile: invitee_profile, share_code: sharecode_from_invitation)
  end

  context 'when user is logged in' do
    before do
      allow(view).to receive(:session).and_return({ userinfo: { 'sub' => '123' }, invitation: { from: @invitation.id } })
      render
    end

    it 'displays a link to take the survey' do
      expect(rendered).to have_button('Take the Survey')
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
