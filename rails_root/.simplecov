# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage :branch # see https://github.com/colszowka/simplecov#branch-coverage-ruby--25
  add_filter '/app/jobs/'
  add_filter '/app/mailers/'
  add_filter '/app/channels/'
end

SimpleCov.merge_timeout 3600
