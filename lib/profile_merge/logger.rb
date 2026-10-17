# frozen_string_literal: true

module ProfileMerge
  # Logging functions
  module Logger
    def self.log(message)
      puts <<~LOG
        #{time_stamp} #{message}

      LOG
    end

    def self.time_stamp
      "[ #{Time.now.strftime("%H:%M:%S.%L")} ]"
    end
  end
end
