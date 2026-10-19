# frozen_string_literal: true

require "optparse"

module Prfl
  class CLI
    # An options parser for the CLI
    class Options
      class Error < Prfl::Error; end
      attr_accessor :list, :all, :no_merge, :parser

      def initialize
        self.parser = OptionParser.new
        parser.banner = "Usage: prfl [options]"
        set_version_option
        set_list_option
        set_all_option
        set_no_merge_option
      end

      def set_version_option
        parser.on("-v", "--version", "Show version") do |_|
          if File.exist?("VERSION")
            puts File.read("VERSION").strip
          else
            puts Prfl::VERSION
          end
          exit
        end
      end

      def set_no_merge_option
        parser.on("-n", "--no-merge", "Skip the merge step") do |_|
          self.no_merge = true
        end
      end

      def set_all_option
        parser.on("-a", "--all", "Fetch data for all new batches") do |a|
          self.all = a
        end
      end

      def set_list_option
        parser.on("-l", "--list BATCHES", Array, "Fetch data for a required list of batch numbers") do |l|
          raise Error, "Arguments to --list must be valid batch numbers" unless l.all? { |arg| arg.match?(/\d{4,}/) }

          self.list = l
        end
      end

      def parse!
        parser.parse!
        return unless list && all

        raise Error, "Cannot combine --list and --all options"
      end
    end
  end
end
