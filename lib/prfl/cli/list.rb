# frozen_string_literal: true

module Prfl
  class CLI
    # An object that stores and modifies the program state when handling
    # the `--list`option
    class List < CLI
      attr_accessor :batch_nums, :old_batch_nums, :new_batch_nums,
                    :existing_profiles

      def initialize(opts)
        super(opts)
        self.batch_nums = []
        self.old_batch_nums = []
        self.new_batch_nums = []
        self.existing_profiles = []
      end

      def filter_old_batch_nums
        opts.list.each do |batch_num|
          if (matching_file = find_matching_file(batch_num))
            old_batch_nums << batch_num
            LOGGER.log(
              "Boost profile data for batch ##{batch_num} already exists at #{config.boost_path}/#{matching_file}"
            )
          else
            batch_nums << batch_num
          end
        end
      end

      def extract_profiles
        self.profiles =
          profile_metadata["profiles"].filter do |profile|
            # only match if the name starts with the batch num followed by white space
            batch_num = extract_batch_num(profile)
            batch_nums.include?(batch_num)
          end
      end

      def find_matching_file(batch_num)
        boost_dir.children.find do |filename|
          filename.match?("_#{batch_num}.json")
        end
      end

      def search_all_profiles
        get_profile_metadata(count: total_roast_count)

        extra_profiles =
          profile_metadata["profiles"].filter do |profile|
            # only match if the name starts with the batch num followed by white space
            batch_num = extract_batch_num(profile)
            batch_nums.include?(batch_num) && profiles.none?(profile)
          end

        profiles.push(*extra_profiles)
      end

      def filter_profiles_and_new_batch_nums
        profiles.reject! do |profile|
          add_filename(profile)
          # The profile may already be in the file system without the batch
          # number as part of the name. We will store what the values of that
          # file would be if it exists
          existing_path, path = extract_paths(profile)

          # While we iterate through the map we remove the batch number from the original
          # args. The remaining batch numbers (args) could not be found on boost
          # or in the file system
          filter_new_batch_nums(profile)

          next unless File.exist?(existing_path)

          # Fix the filename and reject the profile by returning a truthy value
          batch_num = extract_batch_num(profile)
          rename_file(batch_num, existing_path, path)
          new_batch_nums.delete(batch_num) && old_batch_nums << batch_num
          existing_profiles << profile
        end
      end

      def extract_paths(profile)
        path              = "#{config.boost_path}/#{profile["filename"]}"
        existing_filename = "#{profile["prflMCd"]}.json"
        existing_path     = "#{config.boost_path}/#{existing_filename}"
        [existing_path, path]
      end

      def filter_new_batch_nums(profile)
        batch_nums.reject! do |num|
          num == extract_batch_num(profile) && new_batch_nums << num
        end
      end

      def rename_file(batch_num, existing_path, path)
        LOGGER.log(
          "Matched #{batch_num} to existing file #{existing_path}"
        )

        LOGGER.log(
          "Renaming existing file to #{path}"
        )

        File.rename(existing_path, path)
      end
    end
  end
end
