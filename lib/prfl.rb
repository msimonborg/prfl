# frozen_string_literal: true

require_relative "prfl/artisan_data"
require_relative "prfl/boost_data"
require_relative "prfl/boost_driver"
require_relative "prfl/logger"
require_relative "prfl/version"

# Top namespace
module Prfl
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
