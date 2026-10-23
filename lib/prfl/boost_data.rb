# frozen_string_literal: true

module Prfl
  # The object that reads and stores data from a boost file
  class BoostData
    SENSORS = %i[ir bt it dt].freeze

    attr_accessor :source, :data, :timex, :ir_temps, :bt_temps, :it_temps, :dt_temps, :ir_ror, :bt_ror, :it_ror, :dt_ror

    def initialize(filename)
      self.timex = []
      init_temps_and_rors
      file = File.read(filename)
      self.source = file
      self.data = JSON.parse(file)
      extract_data
      derive_rors
    end

    private

    def init_temps_and_rors
      self.ir_temps = []
      self.bt_temps = []
      self.it_temps = []
      self.dt_temps = []
      self.ir_ror = []
      self.bt_ror = []
      self.it_ror = []
      self.dt_ror = []
    end

    def extract_data
      data["temps"].each do |temp|
        add_to_timex(temp)
        add_to_ir_temps(temp)
        add_to_bt_temps(temp)
        add_to_it_temps(temp)
        add_to_dt_temps(temp)
      end
    end

    def add_to_dt_temps(temp)
      dt_temps.push(temp["bandFTemp"].to_f)
    end

    def add_to_it_temps(temp)
      it_temps.push(temp["hotAirFTemp"].to_f)
    end

    def add_to_bt_temps(temp)
      bt_temps.push(temp["internalFTemp"].to_f)
    end

    def add_to_ir_temps(temp)
      ir_temps.push(temp["irFTemp"].to_f)
    end

    def add_to_timex(temp)
      timex.push(temp["rstTime"].to_f)
    end

    def derive_rors
      SENSORS.each do |sensor|
        derive_ror(sensor)
      end
    end

    # sensor is a symbol, one of [:ir, :bt, :it, :dt]
    def derive_ror(sensor)
      temps  = send(:"#{sensor}_temps")
      factor = determine_ror_factor(sensor)

      temps.each_index do |index|
        res = calculate_ror_datapoint(temps, factor, index)

        send(:"#{sensor}_ror").push(res)
      end
    end

    def calculate_ror_datapoint(temps, factor, index)
      if index < 15
        -1.0
      else
        (temps[index].to_f - temps[index - 15].to_f).round(1) * factor
      end
    end

    def determine_ror_factor(sensor)
      # RoR values are computed over a 15 second interval, and multiplied by a
      # factor of 4.0 to produce a F/min delta value. Exception is made for IT
      # which is multiplied by a factor of 10.0/15.0 to produce a F/10sec delta
      # value so it fits inside the Y-axis range of the graph
      if sensor == :it
        10.0 / 15.0
      else
        4.0
      end
    end
  end
end
