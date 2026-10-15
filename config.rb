# frozen_string_literal: true

lookup_path = lambda do |path| 
  Pathname.new("../#{path}").realpath.to_path
end

ProfileMerge.config do |config|
  config.artisan_path = lookup_path.call('roasts')
  config.boost_path = lookup_path.call('boost data/raw')
  config.target_path = lookup_path.call('roasts/merged')
  config.boost_cookie = '06E0AD125B9C921B17A0A5ED8C204DB0'
  config.boost_email = 'matt@carrierroasting.com'
  config.boost_password = 'jepkyj-hampe4-qasnUc'
end