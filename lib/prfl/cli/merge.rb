# frozen_string_literal: true

module Prfl
  class CLI
    # An object that stores and modifies the program state when handling
    # the merge
    class Merge < CLI
      HISTORY = "history.txt"

      attr_accessor :history, :queue

      def lookup_history
        self.history =
          if File.exist?(HISTORY)
            File.read(HISTORY)
          else
            ""
          end
      end

      def build_queue
        self.queue =
          artisan_dir.children.collect do |artisan_file|
            batch_num = extract_batch_num(artisan_file)
            next if batch_num.empty?

            boost_file = find_boost_file(batch_num)
            next unless boost_file && !history.match(batch_num)

            build_queue_member_metadata(batch_num, artisan_file, boost_file)
          end

        # Select only truthy values
        queue.select! { |member| member }
      end

      def extract_batch_num(artisan_file)
        # valid batch number patterns: "#1234", "#12345", "#123456" etc.
        artisan_file.match(/#\d{4,}/).to_s.sub("#", "")
      end

      def find_boost_file(batch_num)
        boost_dir.children.find do |child|
          child.match?("_#{batch_num}.json")
        end
      end

      def build_queue_member_metadata(batch_num, artisan_file, boost_file)
        {
          batch_number: batch_num,
          artisan_file: "#{config.artisan_path}/#{artisan_file}",
          boost_file: "#{config.boost_path}/#{boost_file}",
          target_path: "#{config.target_path}/#{artisan_file}"
        }
      end

      def merge_queue!
        queue.each { |profile| merge! profile }
      end

      def merge!(profile)
        options = build_options(profile)
        artisan_data = Prfl::ArtisanData.new(profile[:artisan_file], options)
        boost_data = Prfl::BoostData.new(profile[:boost_file])

        artisan_data.merge_boost!(boost_data)

        File.write(profile[:target_path], artisan_data.convert_to_raw)

        File.open(HISTORY, "a") do |file|
          file.write("#{profile[:batch_number]} - #{profile[:target_path]}\n")
        end

        LOGGER.log("Merged batch ##{profile[:batch_number]}")
      end

      def build_options(profile)
        { calibrate: profile[:batch_number].to_i <= 7775 }
      end
    end
  end
end
