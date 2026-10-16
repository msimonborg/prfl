# frozen_string_literal: true

lookup_path = lambda do |path|
  Pathname.new("../#{path}").realpath.to_path
end

ProfileMerge.config do |config|
  config.artisan_path = lookup_path.call("roasts/raw")
  config.boost_path = lookup_path.call("boost_data/raw")
  config.target_path = lookup_path.call("roasts/merged")
  config.boost_email = "matt@carrierroasting.com"
  config.boost_password = "jepkyj-hampe4-qasnUc"
end
