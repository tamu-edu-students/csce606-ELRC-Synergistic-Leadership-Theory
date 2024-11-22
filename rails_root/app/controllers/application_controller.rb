# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :log_flash
  helper_method :current_user, :user_is_admin?

  private

  def log_flash
    Rails.logger.info "Flash: #{flash.to_hash}"
  end

  def current_user
    return nil unless session[:userinfo]

    @current_user ||= Struct.new(session[:userinfo])
  end

  def user_is_admin?
    return false unless session[:userinfo]

    # Get roles from the same path used in your Auth0Controller
    user_roles = session[:userinfo]['https://myapp.com/123456789012/roles/roles']
    user_roles&.include?('Admin')
  end

  def authenticate_user!
    redirect_to '/auth/auth0' unless current_user
  end

  def require_admin!
    return if user_is_admin?

    flash[:error] = 'You must be an administrator to access this section'
    redirect_to root_path
  end
end
