# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :log_flash

  private

  def log_flash
    Rails.logger.info "Flash: #{flash.to_hash}"
  end
end
