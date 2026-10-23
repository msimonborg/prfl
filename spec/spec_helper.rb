# frozen_string_literal: true

require "prfl"
require_relative "../config"

# Override the data directories in app config for testing
Prfl.config do |config|
  config.artisan_path = "spec/fixtures/artisan/roasts/raw"
  config.target_path  = "spec/fixtures/artisan/roasts/merged"
  config.boost_path   = "spec/fixtures/boost_data/raw"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
