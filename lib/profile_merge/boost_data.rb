# frozen_string_literal: true

require 'json'

module ProfileMerge
  class BoostData
    SENSORS = [:ir, :bt, :it, :dt]

    attr_accessor :source
    attr_accessor :data
    attr_accessor :timex
    attr_accessor :ir_temps
    attr_accessor :bt_temps
    attr_accessor :it_temps
    attr_accessor :dt_temps
    attr_accessor :ir_ror
    attr_accessor :bt_ror
    attr_accessor :it_ror
    attr_accessor :dt_ror

    def initialize(filename)
      self.timex = []
      self.ir_temps = []
      self.bt_temps = []
      self.it_temps = []
      self.dt_temps = []
      self.ir_ror = []
      self.bt_ror = []
      self.it_ror = []
      self.dt_ror = []

      file = File.read(filename)
      self.source = file
      self.data = JSON.parse(file)
      self.extract_data
      self.derive_rors
    end

    private

    def extract_data
      temps = self.data['temps']

      temps.each do |temp|
        self.timex.push(temp['rstTime'].to_f)
        self.ir_temps.push(temp['irFTemp'].to_f)
        self.bt_temps.push(temp['internalFTemp'].to_f)
        self.it_temps.push(temp['hotAirFTemp'].to_f)
        self.dt_temps.push(temp['bandFTemp'].to_f)
      end
    end

    def derive_rors
      SENSORS.each do |sensor|
        self.derive_ror(sensor)
      end
    end

    # sensor is a symbol, one of [:ir, :bt, :it, :dt]
    def derive_ror(sensor)
      temps = self.send(:"#{sensor}_temps")

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

        self.send(:"#{sensor}_ror").push(res)
      end
    end
  end
end