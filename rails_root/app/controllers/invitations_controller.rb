# frozen_string_literal: true

# The invited user who visited the url will see this page.
class InvitationsController < ApplicationController
  def create
    @survey_response = SurveyResponse.find_by!(share_code: params[:survey_response_share_code])
    @invitation = Invitation.create!(survey_response: @survey_response, created_by_id: @survey_response.profile_id)
    flash[:warning] = "Invitation link created: #{invitation_url(@invitation)}"
    redirect_to survey_response_path(@survey_response)
  end

  def show
    @invitation = Invitation.find(params[:id])
    @invitation.update(visited: true)
    # TODO: (minseo) maybe set the visited timestamp here?
  end
end
