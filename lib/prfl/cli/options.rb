# frozen_string_literal: true

module Prfl
  class CLI
    # An options parser for the CLI
    class Options
      class Error < Prfl::Error; end
      attr_accessor :list, :all, :no_merge, :parser, :candidates, :references

      # Initialize the Options object with a parser that implements the OptionParser interface.
      # The parser is used to define the command-line options and their behavior.
      def initialize(parser)
        self.parser = parser
        parser.banner = "Usage: prfl [options]"
        set_options
      end

      def set_options
        set_version_option
        set_list_option
        set_all_option
        set_no_merge_option
        set_candidates_option
        set_references_option
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
          raise_on_invalid_batch_numbers("list", l)

          self.list = l
        end
      end

      def set_candidates_option
        parser.on("-c", "--candidates BATCHES", Array,
                  "Designate a list of batch numbers as reference candidates") do |c|
          raise_on_invalid_batch_numbers("candidates", c)

          self.candidates = c
        end
      end

      def set_references_option
        parser.on("-r", "--references BATCHES", Array,
                  "Designate a list of batch numbers as reference profiles") do |r|
          raise_on_invalid_batch_numbers("references", r)

          self.references = r
        end
      end

      def raise_on_invalid_batch_numbers(option, args)
        return if args.all? { |arg| batch_num?(arg) }

        raise Error,
              "Arguments to --#{option} must be valid batch numbers"
      end

      def batch_num?(arg)
        arg.match?(/\d{4,}/)
      end

      def parse!
        parser.parse!
        return unless list && all

        raise Error, "Cannot combine --list and --all options"
      end
    end
  end
end
