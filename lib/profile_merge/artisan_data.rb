# frozen_string_literal: true

require 'json'

module ProfileMerge
  class ArtisanData
    CALIBRATION_VALUE = -10.0
    EXTRA_DEVICES = [25, 25, 25, 25]
    EXTRA_NAME_1 = ["IT", "IR", "BT2", "DT2"]
    EXTRA_NAME_2 = ["Delta IT", "Delta IR", "Delta BT2", "Delta DT2"]
    EXTRA_MATH_EXPRESSIONS = ["", "", "", ""]
    EXTRA_DEVICE_COLORS = ["#000000", "#000000", "#000000", "#000000"]
    EXTRA_MARKER_SIZES = [6.0, 6.0, 6.0, 6.0]
    EXTRA_MARKERS = ["null", "null", "null", "null"]
    EXTRA_LINE_WIDTHS = [1.0, 1.0, 1.0, 1.0]
    EXTRA_LINE_STYLES = ["-", "-", "-", "-"]
    EXTRA_DRAW_STYLES = ["default", "default", "default", "default"]

    EXTRA_CURVE_VISIBILITY = [
      false,
      true,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ]

    attr_accessor :source
    attr_accessor :data
    attr_accessor :drop_index

    def initialize(filename)
      self.source = File.read(filename)
      self.data = self.parse_source

      time_index = self.data["timeindex"]
      self.drop_index = time_index[6]

      # self.calibrate_bt
    end

    def merge_boost_data(boost_data)
      self.data["extradevices"].insert(1, *EXTRA_DEVICES)
      self.data["extraname1"].insert(1, *EXTRA_NAME_1)
      self.data["extraname2"].insert(1, *EXTRA_NAME_2)

      extratimex = []

      self.data["timex"].each_index do |i|
        extratimex << (i + 1).to_f
      end


      self.data["extratimex"].insert(1, extratimex, extratimex, extratimex, extratimex)
      self.add_boost_temps(boost_data)

      self.data["extramathexpression1"].insert(1, *EXTRA_MATH_EXPRESSIONS)
      self.data["extramathexpression2"].insert(1, *EXTRA_MATH_EXPRESSIONS)

      self.data["extradevicecolor1"].insert(1, *EXTRA_DEVICE_COLORS)
      self.data["extradevicecolor2"].insert(1, *EXTRA_DEVICE_COLORS)

      self.data["extramarkersizes1"].insert(1, *EXTRA_MARKER_SIZES)
      self.data["extramarkersizes2"].insert(1, *EXTRA_MARKER_SIZES)

      self.data["extramarkers1"].insert(1, *EXTRA_MARKERS)
      self.data["extramarkers2"].insert(1, *EXTRA_MARKERS)

      self.data["extralinewidths1"].insert(1, *EXTRA_LINE_WIDTHS)
      self.data["extralinewidths2"].insert(1, *EXTRA_LINE_WIDTHS)

      self.data["extralinestyles1"].insert(1, *EXTRA_LINE_STYLES)
      self.data["extralinestyles2"].insert(1, *EXTRA_LINE_STYLES)

      self.data["extradrawstyles1"].insert(1, *EXTRA_DRAW_STYLES)
      self.data["extradrawstyles2"].insert(1, *EXTRA_DRAW_STYLES)

      self.data["extraCurveVisibility2"] = EXTRA_CURVE_VISIBILITY
      self.data["extraDelta2"] = EXTRA_CURVE_VISIBILITY

      self
    end


    def convert_to_raw
      string = JSON.generate(self.data)
      string.gsub!("\"", "'")
      string.gsub!("false", "False")
      string.gsub!("true", "True")
      string.gsub!("null", "None")
    end

    private

    def calibrate_bt
      new_bt = []
      
      self.data["temp2"].each do |temp|
        new_bt << (temp + CALIBRATION_VALUE)
      end

      self.data["temp2"] = new_bt
    end

    def add_boost_temps(boost_data)
      pre_pad = []
      post_pad = []
      boost_length = boost_data.timex.length
      artisan_length = self.data["timex"].length

      (1..(self.drop_index - boost_length)).each do |_|
        pre_pad << -1.0
      end

      ((self.drop_index + 1)..artisan_length).each do |_|
        post_pad << -1.0
      end

      temps = [
        boost_data.it_temps,
        boost_data.ir_temps,
        boost_data.bt_temps,
        boost_data.dt_temps
      ]

      rors = [
        boost_data.it_ror,
        boost_data.ir_ror,
        boost_data.bt_ror,
        boost_data.dt_ror
      ]

      temps.collect! do |temp|
        pre_pad + temp + post_pad
      end

      rors.collect! do |ror|
        pre_pad + ror + post_pad
      end

      self.data["extratemp1"].insert(1, *temps)
      self.data["extratemp2"].insert(1, *rors)
    end

    def parse_source
      string = self.source
      string.gsub!("'", "\"")
      string.gsub!("False", "false")
      string.gsub!("True", "true")
      string.gsub!("None", "null")

      JSON.parse(string)
    end
  end
end