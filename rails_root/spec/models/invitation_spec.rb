# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  before do
    profile = SurveyProfile.find_or_create_by(user_id: 1)
    @survey_response = SurveyResponse.create!(share_code: 'SHARECODE', profile_id: profile.id)
  end

  it 'belongs to a survey_response' do
    invitation = Invitation.new(parent_response: @survey_response)
    expect(invitation).to respond_to(:parent_response)
  end

  it 'generates a unique token' do
    invitation1 = Invitation.create!(parent_response: @survey_response)
    invitation2 = Invitation.create!(parent_response: @survey_response)
    expect(invitation1.token).not_to eq(invitation2.token)
  end
end
