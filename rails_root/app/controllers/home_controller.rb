# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  def index
    # @survey_responses = SurveyResponse.where(profile_id: 2) # FIXME: use code below when other part works
    return if session[:userinfo].nil?

    @survey_profile = SurveyProfile.find_by(user_id: session[:userinfo]['sub'])
    puts session[:userinfo]['sub'].to_json
    return if @survey_profile.nil?

    @survey_responses = SurveyResponse.where(profile_id: @survey_profile.id)
  end
end
