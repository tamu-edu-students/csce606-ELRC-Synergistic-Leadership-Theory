# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth0Controller, type: :controller do
  describe '#claim_invitation' do
    before do
      allow(controller).to receive(:redirect_to)
    end

    context 'when the invitation does not exist or has expired' do
      it 'deletes the invitation from the session and returns false' do
        # Set up the session with an invitation that does not exist or has expired
        session[:invitation] = { 'from' => 'nonexistent', 'expiration' => 1.hour.ago }

        # Call the method
        result = controller.send(:claim_invitation)

        # Check that the invitation was deleted from the session
        expect(session[:invitation]).to be_nil

        # Check that the method returned false
        expect(result).to be(false)
      end
    end
  end
end
