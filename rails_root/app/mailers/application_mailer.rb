# frozen_string_literal: true

# rubocop:disable Style/Documentation

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
# rubocop:enable Style/Documentation
