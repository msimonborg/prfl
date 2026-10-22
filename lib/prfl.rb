# frozen_string_literal: true

require "json"
require "optparse"
require "selenium-webdriver"

# Top namespace
module Prfl
  autoload :ArtisanData, "prfl/artisan_data"
  autoload :BoostData, "prfl/boost_data"
  autoload :BoostDriver, "prfl/boost_driver"
  autoload :CLI, "prfl/cli"
  autoload :Config, "prfl/config"
  autoload :Logger, "prfl/logger"
  autoload :VERSION, "prfl/version"

  class Error < StandardError; end

  def self.config(&block)
    return @config unless block_given?

    block.call(@config ||= Config.new)
  end
end
