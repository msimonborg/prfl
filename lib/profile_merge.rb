# frozen_string_literal: true

require_relative 'profile_merge/artisan_data'
require_relative 'profile_merge/boost_data'
require_relative 'profile_merge/version'

module ProfileMerge
  class Error < StandardError; end

  def self.execute(boost_filename, artisan_filename, target_filename)
    boost_data = BoostData.new(boost_filename)
    artisan_data = ArtisanData.new(artisan_filename)
    artisan_data.merge_boost_data(boost_data)
    File.write(target_filename, artisan_data.convert_to_raw)
  end
end
