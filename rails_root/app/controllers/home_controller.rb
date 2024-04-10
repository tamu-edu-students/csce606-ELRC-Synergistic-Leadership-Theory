# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  def index
    return if session[:userinfo].nil?

    redirect_to new_survey_profile_path if SurveyProfile.find_by(user_id: session[:userinfo]['sub']).nil?

    @survey_profile = SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
    return if @survey_profile.nil?

    @survey_responses = SurveyResponse.where(profile_id: @survey_profile.id)
  end
end
