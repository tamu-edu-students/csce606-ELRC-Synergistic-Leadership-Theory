# frozen_string_literal: true

# spec/controllers/home_controller_spec.rb
require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do
    @inviter_profile = SurveyProfile.create!(user_id: '1', first_name: 'Gary', last_name: 'Chalmers', campus_name: 'Springfield Elementary', district_name: 'Springfield', role: 'Superintendent')
    invitee_profile = SurveyProfile.create!(user_id: '2', first_name: 'Seymour', last_name: 'Skinner', campus_name: 'Springfield Elementary', district_name: 'Springfield', role: 'Principal')
    parent_survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: @inviter_profile.id)

    @invitation = Invitation.create!(parent_response_id: parent_survey_response.id, visited: false, last_sent: Time.now)
    sharecode_from_invitation = @invitation.parent_response.share_code
    @new_response_to_fill = SurveyResponse.create(profile: invitee_profile, share_code: sharecode_from_invitation)
    @invitation.update!(response_id: @new_response_to_fill.id, claimed_by_id: invitee_profile.id)

    session[:userinfo] = { 'sub' => invitee_profile.user_id }
  end

  describe 'GET #index' do
    it 'fetches survey responses' do
      get :index
      expect(assigns(:survey_responses)).to eq([@new_response_to_fill])
    end

    it 'fetches invitations' do
      get :index

      parent_response = @invitation.parent_response
      profile = parent_response.profile

      expected_invited_by = profile.nil? ? 'N/A' : "#{profile.first_name} #{profile.last_name}"

      actual_invitations = assigns(:invitations)

      expect(actual_invitations).to eq([expected_invited_by])
    end
  end
end
