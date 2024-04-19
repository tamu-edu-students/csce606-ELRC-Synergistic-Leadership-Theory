# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController

  helper_method :invite_token
  def index
    return if session[:userinfo].nil?

    redirect_to new_survey_profile_path if SurveyProfile.find_by(user_id: session[:userinfo]['sub']).nil?

    @survey_profile = SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
    return if @survey_profile.nil?

    @survey_responses = fetch_survey_responses
    @invitations = fetch_invitations
  end

  private

  def fetch_survey_responses
    SurveyResponse.where(profile_id: @survey_profile.id)
  end

  def fetch_invitations
    @survey_responses.map do |response|
      invitation = Invitation.find_by(response_id: response.id)
      invitation ? fetch_invited_by(invitation) : 'N/A'
    end
  end

  def fetch_invited_by(invitation)
    parent_response = SurveyResponse.find(invitation.parent_response_id)
    profile = SurveyProfile.find(parent_response.profile_id) if parent_response
    "#{profile.first_name} #{profile.last_name}" if profile
  end

  def invite_token(response)
    invitation = Invitation.find_by(response_id: response.id)
    invitation ? invitation.token : 'N/A'
  end
end
