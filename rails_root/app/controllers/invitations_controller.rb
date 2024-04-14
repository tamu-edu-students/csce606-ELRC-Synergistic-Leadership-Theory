# frozen_string_literal: true

# The invited user who visited the url will see this page.
class InvitationsController < ApplicationController
  def create
    @survey_response = SurveyResponse.find_by!(share_code: params[:survey_response_share_code])
    @invitation = Invitation.create!(parent_response: @parent_survey_response, last_sent: Time.now, visited: false)

    redirect_to invitation_created_invitation_path(@invitation.token)
  end

  def show
    @invitation = Invitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.visited
      redirect_to not_found_invitations_path
    else
      @invitation.update(visited: true)

      if session[:userinfo].present?
        user_id = session[:userinfo]['sub']
        user_profile = SurveyProfile.find_by(user_id:)

        claim_invitation(user_profile) if user_profile
      end

      session[:invitation] = { share_code: @invitation.parent_response.share_code, expiration: 15.minute.from_now }
    end
  end

  def not_found
    render :not_found
  end

  def invitation_created
    @invitation = Invitation.find_by(token: params[:token])

    return unless @invitation.nil?

    redirect_to not_found_invitations_path
  end

  private

  def claim_invitation(user_profile)
    sharecode_from_invitation = @invitation.parent_response.share_code

    @new_response_to_fill = SurveyResponse.create(profile: user_profile, share_code: sharecode_from_invitation)

    @invitation.update(claimed_by_id: user_profile.id, response_id: @new_response_to_fill.id)
  end
end
