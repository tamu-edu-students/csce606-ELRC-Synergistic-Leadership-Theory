# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  def index
    return if session[:userinfo].nil?

    redirect_to new_survey_profile_path if SurveyProfile.find_by(user_id: session[:userinfo]['sub']).nil?

    @survey_profile = SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
    return if @survey_profile.nil?

    @survey_responses = fetch_survey_responses
  end

  private

  def fetch_survey_responses
    SurveyResponse.where(profile_id: @survey_profile.id).map do |response|
      { response:, invited_by: fetch_invited_by(response) }
    end
  end

  def fetch_invited_by(response)
    invitation = Invitation.find_by(response_id: response.id)
    parent_response = SurveyResponse.find(invitation.parent_response_id) if invitation
    profile = SurveyProfile.find(parent_response.profile_id) if parent_response
    name = "#{profile.first_name} #{profile.last_name}" if profile
    name || 'N/A'
  end
end
