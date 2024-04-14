# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invitations/show', type: :view do
  before do
    @invitation = assign(:invitation, Invitation.create!(parent_response_id: parent_survey_response.id, visited: false, last_sent: Time.now))
  end

  context 'when user is logged in' do
    before do
      allow(view).to receive(:session).and_return({ userinfo: { 'sub' => '123' }, invitation: { share_code: 'SHARECODE' } })
      render
    end

    it 'displays a link to take the survey' do
      expect(rendered).to have_link('Take the Survey', href: new_survey_response_path(share_code: 'SHARECODE'))
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
