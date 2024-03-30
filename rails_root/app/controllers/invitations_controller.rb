# frozen_string_literal: true

# The invited user who visited the url will see this page.
class InvitationsController < ApplicationController
  def create
    @survey_response = SurveyResponse.find_by!(share_code: params[:survey_response_share_code])
    @invitation = Invitation.create!(parent_response: @survey_response, created_by_id: @survey_response.profile_id)
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
      # TODO: (minseo) maybe set the visited timestamp here?

      session[:invitation] = { share_code: @invitation.parent_response.share_code, expiration: 15.minute.from_now }
    end
  end
end
