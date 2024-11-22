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
    @current_user ||= OpenStruct.new(session[:userinfo])
  end

  def user_roles
    session[:userinfo]&.dig('https://myapp.com/123456789012/roles/roles')
  end

  def user_is_admin?
    user_roles&.include?('Admin')
  end

  def authenticate_user!
    redirect_to '/auth/auth0' unless current_user
  end
  
  def require_admin!
    unless user_is_admin?
      flash[:error] = "You must be an administrator to access this section"
      redirect_to root_path
    end
  end
end
