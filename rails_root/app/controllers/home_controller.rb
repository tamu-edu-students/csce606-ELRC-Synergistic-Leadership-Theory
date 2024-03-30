# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  def index
    @survey_responses = SurveyResponse.where(profile_id: 2) # FIXME: use code below when other part works
    # @survey_profile = SurveyProfile.find_by(user_id: session[:userinfo]["sub"])
    # @survey_responses = SurveyResponse.where(profile_id: session[:userinfo]["sub"])
  end
end
