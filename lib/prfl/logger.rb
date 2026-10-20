# frozen_string_literal: true

module Prfl
  # Logging functions
  module Logger
    def log(message)
      puts <<~LOG
        #{time_stamp} #{message}

      LOG
    end

    def time_stamp
      "[ #{Time.now.strftime("%H:%M:%S.%L")} ]"
    end
  end
end
