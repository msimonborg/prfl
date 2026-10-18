# frozen_string_literal: true

require_relative "cli/all"
require_relative "cli/list"
require_relative "cli/merge"
require_relative "cli/options"
require_relative "boost_driver"

module ProfileMerge
  # Superclass of all CLI subprograms
  class CLI
    attr_accessor :opts, :driver, :profile_metadata, :total_roast_count,
                  :response, :profiles, :config, :boost_dir, :artisan_dir,
                  :target_dir, :fetch_list

    def initialize(opts)
      self.opts = opts
      self.profile_metadata = []
      self.profiles = []
      self.fetch_list = []
      self.config = ProfileMerge.config
      set_dirs
    end

    def set_dirs
      self.boost_dir = Dir.new(config.boost_path)
      self.artisan_dir = Dir.new(config.artisan_path)
      self.target_dir = Dir.new(config.target_path)
    end

    def new_boost_session
      self.driver = ProfileMerge::BoostDriver.new
      driver.new_session
    end

    def get_profile_metadata(options = {})
      self.response = driver.get_profile_metadata(options)
      self.profile_metadata = JSON.parse(response)
      self.total_roast_count = profile_metadata["totalRstCnt"]
    end

    def fetch_profile_data
      File.write("fetch_list.json", JSON.generate(fetch_list))
      File.write("cookie", driver.cookie)

      IO.popen("bin/fetch_profile_data").each { |line| LOGGER.log line }
    end

    def extract_batch_num(profile)
      profile["prflName"].match(/^\d{4,}\b/).to_s
    end

    def add_filename(profile)
      id = profile["prflMCd"]
      batch_num = extract_batch_num(profile)

      filename =
        if batch_num
          "#{id}_#{batch_num}.json"
        else
          "#{id}.json"
        end

      profile["filename"] = "#{filename}"
    end

    def build_fetch_list
      self.fetch_list =
        profiles.map do |profile|
          { id: profile["prflMCd"], filename: profile["filename"] }
        end
    end
  end
end
