# frozen_string_literal: true

require "prfl"
require_relative "../config"

# Override the data directories in app config for testing
Prfl.config do |config|
  config.artisan_path = Pathname.new("spec/fixtures/artisan/roasts/raw").realpath.to_path
  config.target_path  = Pathname.new("spec/fixtures/artisan/roasts/merged").realpath.to_path
  config.boost_path   = Pathname.new("spec/fixtures/boost_data/raw").realpath.to_path
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
