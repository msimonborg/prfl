# frozen_string_literal: true

require "json"

module ProfileMerge
  # The object that reads and stores data from a boost file
  class BoostData
    SENSORS = %i[ir bt it dt]

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
      temps = data["temps"]

      temps.each do |temp|
        timex.push(temp["rstTime"].to_f)
        ir_temps.push(temp["irFTemp"].to_f)
        bt_temps.push(temp["internalFTemp"].to_f)
        it_temps.push(temp["hotAirFTemp"].to_f)
        dt_temps.push(temp["bandFTemp"].to_f)
      end
    end

    def derive_rors
      SENSORS.each do |sensor|
        derive_ror(sensor)
      end
    end

    # sensor is a symbol, one of [:ir, :bt, :it, :dt]
    def derive_ror(sensor)
      temps = send(:"#{sensor}_temps")

      # RoR values are computed over a 15 second interval, and multiplied by a
      # factor of 4.0 to produce a F/min delta value. Exception is made for IT
      # which is multiplied by a factor of 10.0/15.0 to produce a F/10sec delta
      # value so it fits inside the Y-axis range of the graph
      factor =
        if sensor == :it
          10.0 / 15.0
        else
          4.0
        end

      temps.each_index do |i|
        res =
          if i < 15
            -1.0
          else
            (temps[i].to_f - temps[i - 15].to_f).round(1) * factor
          end

        send(:"#{sensor}_ror").push(res)
      end
    end
  end
end
