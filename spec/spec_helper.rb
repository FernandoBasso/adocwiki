# SPDX-License-Identifier: GPL-3.0-or-later

require "adoc_wiki"
require "#{__dir__}/support/adoc_helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include AdocHelpers
end
