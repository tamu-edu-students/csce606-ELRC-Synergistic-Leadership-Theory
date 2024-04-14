# frozen_string_literal: true

# The invited user who visited the url will see this page.
class InvitationsController < ApplicationController
  def create
    @survey_response = SurveyResponse.find_by!(share_code: params[:survey_response_share_code])
    @invitation = Invitation.create!(parent_response: @parent_survey_response, last_sent: Time.now, visited: false)
    flash[:warning] = "Invitation link created: #{invitation_url(@invitation.token)}"
    redirect_to survey_response_path(@survey_response)
  end

  def show
    @invitation = Invitation.find_by(token: params[:token])

    if @invitation.nil?
      flash[:error] = 'This invitation link has expired.'
      redirect_to root_path
    elsif @invitation.visited # don't give more info
      flash[:error] = 'This invitation link has expired.'
      redirect_to root_path
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
  def claim_invitation(user_profile)
    sharecode_from_invitation = @invitation.parent_response.share_code

    @new_response_to_fill = SurveyResponse.create(profile: user_profile, share_code: sharecode_from_invitation)

    @invitation.update(claimed_by_id: user_profile.id, response_id: @new_response_to_fill.id)
  end
end
