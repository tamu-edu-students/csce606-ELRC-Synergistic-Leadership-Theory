# frozen_string_literal: true

# Run simplecov before any tests to capture all test coverage
require 'simplecov'
require 'simplecov_json_formatter'
require 'rack_session_access/capybara'
SimpleCov.formatters = [
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.command_name 'specs'

# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
# disable all cops for this file
#rubocop:disable all
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.
  #   # This allows you to limit a spec run to individual examples or groups
  #   # you care about by tagging them with `:focus` metadata. When nothing
  #   # is tagged with `:focus`, all examples get run. RSpec also provides
  #   # aliases for `it`, `describe`, and `context` that include `:focus`
  #   # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  #   config.filter_run_when_matching :focus
  #
  #   # Allows RSpec to persist some state between runs in order to support
  #   # the `--only-failures` and `--next-failure` CLI options. We recommend
  #   # you configure your source control system to ignore this file.
  #   config.example_status_persistence_file_path = "spec/examples.txt"
  #
  #   # Limits the available syntax to the non-monkey patched syntax that is
  #   # recommended. For more details, see:
  #   # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  #   config.disable_monkey_patching!
  #
  #   # Many RSpec users commonly either run the entire suite or an individual
  #   # file, and it's useful to allow more verbose output when running an
  #   # individual spec file.
  #   if config.files_to_run.one?
  #     # Use the documentation formatter for detailed output,
  #     # unless a formatter has already been configured
  #     # (e.g. via a command-line flag).
  #     config.default_formatter = "doc"
  #   end
  #
  #   # Print the 10 slowest examples and example groups at the
  #   # end of the spec run, to help surface which specs are running
  #   # particularly slow.
  #   config.profile_examples = 10
  #
  #   # Run specs in random order to surface order dependencies. If you find an
  #   # order dependency and want to debug it, you can fix the order by providing
  #   # the seed, which is printed after each run.
  #   #     --seed 1234
  #   config.order = :random
  #
  #   # Seed global randomization in this process using the `--seed` CLI option.
  #   # Setting this allows you to use `--seed` to deterministically reproduce
  #   # test failures related to randomization by passing the same `--seed` value
  #   # as the one that triggered the failure.
  #   Kernel.srand config.seed
  #
  #
  # ignore line length
  def mock_auth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({ provider: 'auth0',
                                                                 uid: 'google-oauth2|100507718411999601151',
                                                                 info: {
                                                                   name: 'John Doe',
                                                                   nickname: 'JohntDoe',
                                                                   email: nil,
                                                                   image: 'https://lh3.googleusercontent.com/a/ACg8ocKu35mWhT-SFKeIcdUqWE-L3MqSUHtKTZYNH8cA1lC98oE=s96-c'
                                                                 },
                                                                 credentials: {
                                                                   token: 'eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiaXNzIjoiaHR0cHM6Ly9kZXYtemNmdWNrM3hnN3c1djZzYS51cy5hdXRoMC5jb20vIn0..H0PuCkDtR_V2yeJT.r6XP3TPa2Bho1wmCsE0YdGkIBciyKOPR_3K4iZvDWLmynB5mYfRwr_gJ4ZX0E9aUpRAboJ4R9VpKYySlhIgw6RC_3UhGjEgciJumb_yqbGZJfG3OQ86GEq-iCgJJgnLGB1x-q7OykkFD-NvcL-ezhbfc8khAZJfHypupFEVIneTs9Jdi4Wp5jJdsmQ6Y_-O5pACQcp5WhpQ42-Jz_mbL_f-ogs5rngRjRmmujDNgwzIQvSwYLo6yxc1C71IoDAX1PwbZVImu_jttICuUJV1GnftNvvVwb4CLQCNaEjJ386qoNTRbN6m1MjcyAuPKa3DBKmgNGNSykTD2ZZGtPwfp5Xg.lEoIk0uUzvfB97t9qLxJNQ',
                                                                   expires_at: 1_711_507_739,
                                                                   expires: true,
                                                                   id_token: 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlpmZjNwUk9SWU83WGlwcVNLcFl2cCJ9.eyJnaXZlbl9uYW1lIjoiSmFjb2IiLCJmYW1pbHlfbmFtZSI6Ik1hdGhlcyIsIm5pY2tuYW1lIjoiamFjb2J0bWF0aGVzIiwibmFtZSI6IkphY29iIE1hdGhlcyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NLdTM1bVdoVC1TRktlSWNkVXFXRS1MM01xU1VIdEtUWllOSDhjQTFsQzk4b0U9czk2LWMiLCJsb2NhbGUiOiJlbiIsInVwZGF0ZWRfYXQiOiIyMDI0LTAzLTI2VDAyOjQ4OjU4Ljk3NVoiLCJpc3MiOiJodHRwczovL2Rldi16Y2Z1Y2szeGc3dzV2NnNhLnVzLmF1dGgwLmNvbS8iLCJhdWQiOiI0bFQwM2w1R1FudlhJOFhBVUtBdGZMeEROVUJUd2tsQSIsImlhdCI6MTcxMTQyMTMzOSwiZXhwIjoxNzExNDU3MzM5LCJzdWIiOiJnb29nbGUtb2F1dGgyfDEwMDUwNzcxODQxMTk5OTYwMTE1MSIsInNpZCI6ImIxdjFjcmJYdlR1dDVBbUJYNVUtRFcwVVVwZUhiQU5EIiwibm9uY2UiOiJlMjU3OGFhYmFjYjhkNmIyMDFjMDZmMTY1MTQ2YzZmYSJ9.YMYTRfNWr2FSpB5UU1cn6zqXakiYuOmCkitasZcWbDVRdWiOOFasJ9fdGx19e3H-c6KliHKdUL6R4aIglf16Y_NN8YeR5SpsGz8o8adSHGXhO_O96hV0LW-D-Hx1GRzP95c0phdQ6Vgom-ql-DL2p2agmdgwIxuN4DNmQitX3Nndtlbky5vTzw9GNuCQrQx5pijELlMXN6bbVXyGlDcPxNyA0a3DCGbdqA-4TqdCa8eOmdAmXYCgvKq3EJO7c6X9KnLHPWEGHhOxraGy7uTAv64EkoreGffa73YueDNlbIcV4uDWlQ1SjOLParvojmxpjo8DnTB8N8jWNPGsoziymA',
                                                                   token_type: 'Bearer',
                                                                   refresh_token: nil
                                                                 },
                                                                 extra: {
                                                                   raw_info: {
                                                                     given_name: 'John',
                                                                     family_name: 'Doe',
                                                                     nickname: 'JohntDoe',
                                                                     name: 'John Doe',
                                                                     picture: 'https://lh3.googleusercontent.com/a/ACg8ocKu35mWhT-SFKeIcdUqWE-L3MqSUHtKTZYNH8cA1lC98oE=s96-c',
                                                                     locale: 'en',
                                                                     updated_at: '2024-03-26T02:48:58.975Z',
                                                                     iss: 'https://dev-zcfuck3xg7w5v6sa.us.auth0.com/',
                                                                     aud: '4lT03l5GQnvXI8XAUKAtfLxDNUBTwklA',
                                                                     iat: 1_711_421_339,
                                                                     exp: 1_711_457_339,
                                                                     sub: 'google-oauth2|100507718411999601151',
                                                                     sid: 'b1v1crbXvTut5AmBX5U-DW0UUpeHbAND',
                                                                     nonce: 'e2578aabacb8d6b201c06f165146c6fa'
                                                                   }
                                                                 } })

    # Call callback method
    get '/auth/auth0/callback'
  end
end
#rubocop:enable all