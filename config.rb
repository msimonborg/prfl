# frozen_string_literal: true

dev_path = ->(path) { Pathname.new("data/#{path}").realpath.to_path }

if ENV["PRFL_ENV"] == "prod"
  Prfl.config do |config|
    config.artisan_path = ENV.fetch("PRFL_ARTISAN_PATH", nil)
    config.boost_path   = ENV.fetch("PRFL_BOOST_PATH", nil)
    config.target_path  = ENV.fetch("PRFL_TARGET_PATH", nil)
  end
else
  Prfl.config do |config|
    config.artisan_path = dev_path.call("artisan/roasts/raw")
    config.boost_path   = dev_path.call("boost_data/raw")
    config.target_path  = dev_path.call("artisan/roasts/merged")
  end
end

Prfl.config do |config|
  config.boost_email    = ENV.fetch("PRFL_BOOST_EMAIL", nil)
  config.boost_password = ENV.fetch("PRFL_BOOST_PASSWORD", nil)
end
