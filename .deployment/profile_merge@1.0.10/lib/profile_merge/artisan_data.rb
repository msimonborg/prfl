# frozen_string_literal: true

require "json"

module ProfileMerge
  class ArtisanData
    CALIBRATION_VALUE = -10.0
    EXTRA_DEVICES = [25, 25, 25, 25]
    EXTRA_NAME_1 = %w[IT IR BT2 DT2]
    EXTRA_NAME_2 = ["Delta IT", "Delta IR", "Delta BT2", "Delta DT2"]
    EXTRA_MATH_EXPRESSIONS = ["", "", "", ""]
    EXTRA_DEVICE_COLORS = ["#000000", "#000000", "#000000", "#000000"]
    EXTRA_MARKER_SIZES = [6.0, 6.0, 6.0, 6.0]
    EXTRA_MARKERS = %w[null null null null]
    EXTRA_LINE_WIDTHS = [1.0, 1.0, 1.0, 1.0]
    EXTRA_LINE_STYLES = ["-", "-", "-", "-"]
    EXTRA_DRAW_STYLES = %w[default default default default]

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

    attr_accessor :source, :data, :drop_index

    def initialize(filename, options)
      self.source = File.read(filename)
      self.data = parse_source

      time_index = data["timeindex"]
      self.drop_index = time_index[6]

      calibrate_bt if options[:calibrate] == true
    end

    def merge_boost!(boost_data)
      data["extradevices"].insert(1, *EXTRA_DEVICES)
      data["extraname1"].insert(1, *EXTRA_NAME_1)
      data["extraname2"].insert(1, *EXTRA_NAME_2)

      extratimex = []

      # extratimex = [1.0, 2.0, 3.0, ...]
      data["timex"].each_index do |i|
        extratimex << (i + 1).to_f
      end

      extratimex = [
        extratimex,
        extratimex,
        extratimex,
        extratimex
      ]

      data["extratimex"].insert(1, *extratimex)
      add_boost_temps(boost_data)

      data["extramathexpression1"].insert(1, *EXTRA_MATH_EXPRESSIONS)
      data["extramathexpression2"].insert(1, *EXTRA_MATH_EXPRESSIONS)

      data["extradevicecolor1"].insert(1, *EXTRA_DEVICE_COLORS)
      data["extradevicecolor2"].insert(1, *EXTRA_DEVICE_COLORS)

      data["extramarkersizes1"].insert(1, *EXTRA_MARKER_SIZES)
      data["extramarkersizes2"].insert(1, *EXTRA_MARKER_SIZES)

      data["extramarkers1"].insert(1, *EXTRA_MARKERS)
      data["extramarkers2"].insert(1, *EXTRA_MARKERS)

      data["extralinewidths1"].insert(1, *EXTRA_LINE_WIDTHS)
      data["extralinewidths2"].insert(1, *EXTRA_LINE_WIDTHS)

      data["extralinestyles1"].insert(1, *EXTRA_LINE_STYLES)
      data["extralinestyles2"].insert(1, *EXTRA_LINE_STYLES)

      data["extradrawstyles1"].insert(1, *EXTRA_DRAW_STYLES)
      data["extradrawstyles2"].insert(1, *EXTRA_DRAW_STYLES)

      data["extraCurveVisibility1"] = (1..10).map { |_| true }
      data["extraCurveVisibility2"] = EXTRA_CURVE_VISIBILITY
      data["extraDelta2"] = EXTRA_CURVE_VISIBILITY

      self
    end

    def convert_to_raw
      string = JSON.generate(data)
      string.gsub!("\"", "'")
      string.gsub!("false", "False")
      string.gsub!("true", "True")
      string.gsub!("null", "None")
    end

    private

    def calibrate_bt
      data["temp2"].map! do |temp|
        temp + CALIBRATION_VALUE
      end
    end

    def add_boost_temps(boost_data)
      pre_pad = []
      post_pad = []

      boost_length = boost_data.timex.length
      artisan_length = data["timex"].length

      (1..(drop_index - boost_length)).each do |_|
        pre_pad << -1.0
      end

      ((drop_index + 1)..artisan_length).each do |_|
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

      data["extratemp1"].insert(1, *temps)
      data["extratemp2"].insert(1, *rors)
    end

    def parse_source
      string = source
      string.gsub!("'", "\"")
      string.gsub!("False", "false")
      string.gsub!("True", "true")
      string.gsub!("None", "null")

      JSON.parse(string)
    end
  end
end
