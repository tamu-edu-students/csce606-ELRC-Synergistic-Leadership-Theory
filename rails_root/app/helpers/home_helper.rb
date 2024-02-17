# frozen_string_literal: true

# Helper methods for the home controller
module HomeHelper
  def greeting_message
    current_hour = Time.zone.now.hour
    case current_hour
    when 5..11
      'Good morning!'
    when 12..17
      'Good afternoon!'
    when 18..23, 0..4
      'Good evening!'
    else
      'Hello!'
    end
  end
end
