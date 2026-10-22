# frozen_string_literal: true

module Prfl
  class CLI
    # An object that stores and modifies the program state when handling
    # the `--all` option
    class All < CLI
      attr_accessor :counter, :new_count

      def set_count
        self.counter = File.read("counter").to_i
        self.new_count = total_roast_count - counter
      end

      def extract_profiles
        # The response should be sorted by most recent datetime, but we will
        # do it anyway just in case, and take only the first `new_count` profiles
        self.profiles =
          profile_metadata["profiles"].sort do |a, b|
            b["rstDt"] <=> a["rstDt"]
          end.take(new_count)
      end

      def filter_profiles
        # Exlude profiles that match Onyx Tonics' naming conventions
        profiles.filter! do |profile|
          name = profile["prflName"]
          !match_onyx_tonics?(name)
        end
      end

      def match_onyx_tonics?(name)
        name.match?(/(^|\s)\d{4,}\w/) || name.match?(/(^|\s)bi($|\s)/i)
      end

      def update_counter
        File.write("counter", total_roast_count)
      end
    end
  end
end
