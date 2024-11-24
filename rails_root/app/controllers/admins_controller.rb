# frozen_string_literal: true

# admins_controller.rb
class AdminsController < ApplicationController
  def index
    return return_to_root 'You cannot view this result.' unless user_is_admin?

    @survey_responses = SurveyResponse.get_all_responses(page: params[:page], per_page: 20)
  end

  def return_to_root(message)
    respond_to do |format|
      format.html do
        redirect_to root_url, notice: message
      end
      format.json { render json: { error: message }, status: }
    end
  end
end
