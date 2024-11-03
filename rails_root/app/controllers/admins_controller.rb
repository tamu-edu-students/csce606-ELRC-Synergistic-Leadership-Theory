# frozen_string_literal: true

# admins_controller.rb
class AdminsController < ApplicationController
  def index
    @survey_responses = SurveyResponse.get_all_responses(page: params[:page], per_page: 20)
  end
end
