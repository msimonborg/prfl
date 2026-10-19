# frozen_string_literal: true

dev_path = ->(path) { Pathname.new("data/#{path}").realpath.to_path }

if ENV["PRFL_ENV"] == "prod"
  ProfileMerge.config do |config|
    config.artisan_path =  ENV["PRFL_ARTISAN_PATH"]
    config.boost_path   = ENV["PRFL_BOOST_PATH"]
    config.target_path  = ENV["PRFL_TARGET_PATH"]
  end
else
  ProfileMerge.config do |config|
    config.artisan_path = dev_path.call("artisan/roasts/raw")
    config.boost_path   = dev_path.call("boost_data/raw")
    config.target_path  = dev_path.call("artisan/roasts/merged")
  end
end

ProfileMerge.config do |config|
  config.boost_email    = ENV["PRFL_BOOST_EMAIL"]
  config.boost_password = ENV["PRFL_BOOST_PASSWORD"]
end
