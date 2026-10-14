# frozen_string_literal: true

lookup_path = lambda do |path| 
  Pathname.new("../#{path}").realpath.to_path
end

ProfileMerge.config do |config|
  config.artisan_path = lookup_path.call('roasts')
  config.boost_path = lookup_path.call('boost data/raw')
  config.target_path = lookup_path.call('roasts/merged')
  config.boost_cookie = 'A549422F881D46FB89BE7EB2D76D68DE'
end