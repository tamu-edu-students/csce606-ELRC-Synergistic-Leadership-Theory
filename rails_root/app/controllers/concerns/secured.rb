# frozen_string_literal: true

# ./app/controllers/concerns/secured.rb
module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?
  end

  def logged_in_using_omniauth?
    logger.info '========== logged_in_using_omniauth triggered =========='
    redirect_to '/' unless session[:userinfo].present?
    # flash[:warning] = 'You are not logged in!'
  end
end
