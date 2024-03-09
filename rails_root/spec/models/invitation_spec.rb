# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it 'belongs to a survey_response' do
    invitation = Invitation.new
    expect(invitation).to respond_to(:survey_response)
  end

  it 'belongs to a created_by' do
    invitation = Invitation.new
    expect(invitation).to respond_to(:created_by)
  end
end
