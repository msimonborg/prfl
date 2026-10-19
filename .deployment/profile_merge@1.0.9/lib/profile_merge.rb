# frozen_string_literal: true

require_relative "profile_merge/artisan_data"
require_relative "profile_merge/boost_data"
require_relative "profile_merge/boost_driver"
require_relative "profile_merge/logger"
require_relative "profile_merge/version"

module ProfileMerge
  class Error < StandardError; end

  class Config
    attr_accessor :artisan_path,
                  :boost_path,
                  :target_path,
                  :boost_email,
                  :boost_password,
                  :browser
  end

  @@config = false

  def self.config(&block)
    return @@config unless block_given?

    @@config ||= Config.new
    block.call(@@config)
  end
end
