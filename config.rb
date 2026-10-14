# frozen_string_literal: true

lookup_path = lambda do |path| 
  Pathname.new("../#{path}").realpath.to_path
end

ProfileMerge.config do |config|
  config.artisan_path = lookup_path.call('roasts')
  config.boost_path = lookup_path.call('boost data/raw')
  config.target_path = lookup_path.call('roasts/merged')
  config.boost_cookie = '1816E9D94374A4953BA2A19783DA59B6'
end