# frozen_string_literal: true

module Prfl
  # Class for creating Artisan profile data objects
  class ArtisanData
    CALIBRATION_VALUE = -10.0
    EXTRA_DEVICES          = [25, 25, 25, 25].freeze
    EXTRA_NAME_1           = %w[IT IR BT2 DT2].freeze
    EXTRA_NAME_2           = ["Delta IT", "Delta IR", "Delta BT2", "Delta DT2"].freeze
    EXTRA_MATH_EXPRESSIONS = ["", "", "", ""].freeze
    EXTRA_DEVICE_COLORS    = ["#000000", "#000000", "#000000", "#000000"].freeze
    EXTRA_MARKER_SIZES     = [6.0, 6.0, 6.0, 6.0].freeze
    EXTRA_MARKERS          = %w[null null null null].freeze
    EXTRA_LINE_WIDTHS      = [1.0, 1.0, 1.0, 1.0].freeze
    EXTRA_LINE_STYLES      = ["-", "-", "-", "-"].freeze
    EXTRA_DRAW_STYLES      = %w[default default default default].freeze
    EXTRA_CURVE_VISIBILITY = [false, true, true, false, false, false, false, false, false, false].freeze

    REQUIREMENTS = { "extradevices" => EXTRA_DEVICES,
                     "extraname1" => EXTRA_NAME_1,
                     "extraname2" => EXTRA_NAME_2,
                     "extramathexpression1" => EXTRA_MATH_EXPRESSIONS,
                     "extramathexpression2" => EXTRA_MATH_EXPRESSIONS,
                     "extradevicecolor1" => EXTRA_DEVICE_COLORS,
                     "extradevicecolor2" => EXTRA_DEVICE_COLORS,
                     "extramarkersizes1" => EXTRA_MARKER_SIZES,
                     "extramarkersizes2" => EXTRA_MARKER_SIZES,
                     "extramarkers1" => EXTRA_MARKERS,
                     "extramarkers2" => EXTRA_MARKERS,
                     "extralinewidths1" => EXTRA_LINE_WIDTHS,
                     "extralinewidths2" => EXTRA_LINE_WIDTHS,
                     "extralinestyles1" => EXTRA_LINE_STYLES,
                     "extralinestyles2" => EXTRA_LINE_STYLES,
                     "extradrawstyles1" => EXTRA_DRAW_STYLES,
                     "extradrawstyles2" => EXTRA_DRAW_STYLES }.freeze

    attr_accessor :source, :data, :drop_index

    def initialize(filename, options)
      self.source = File.read(filename)
      self.data = parse_source

      time_index = data["timeindex"]
      self.drop_index = time_index[6]

      calibrate_bt if options[:calibrate] == true
    end

    def merge_boost!(boost_data)
      extratimex = []
      # extratimex = [1.0, 2.0, 3.0, ...]
      data["timex"].each_index { |i| extratimex << (i + 1).to_f }

      extratimex = (1..4).map { |_| extratimex }
      data["extratimex"].insert(1, *extratimex)

      add_boost_temps(boost_data)
      set_curve_visibility
      add_requirements

      self
    end

    def set_curve_visibility
      data["extraDelta2"]           = EXTRA_CURVE_VISIBILITY
      data["extraCurveVisibility1"] = (1..10).map { |_| true }
      data["extraCurveVisibility2"] = EXTRA_CURVE_VISIBILITY
    end

    def add_requirements
      REQUIREMENTS.each { |k, v| data[k].insert(1, *v) }
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
      boost_length   = boost_data.timex.length
      artisan_length = data["timex"].length

      pre_pad  = (1..(drop_index - boost_length)).map { |_| -1.0 }
      post_pad = ((drop_index + 1)..artisan_length).map { |_| -1.0 }

      temps = build_temps(boost_data, pre_pad, post_pad)
      rors  = build_rors(boost_data, pre_pad, post_pad)

      insert_temps_and_rors(temps, rors)
    end

    def insert_temps_and_rors(temps, rors)
      data["extratemp1"].insert(1, *temps)
      data["extratemp2"].insert(1, *rors)
    end

    def build_rors(boost_data, pre_pad, post_pad)
      %w[it_ror ir_ror bt_ror dt_ror].map do |sym|
        pre_pad + boost_data.send(sym) + post_pad
      end
    end

    def build_temps(boost_data, pre_pad, post_pad)
      %w[it_temps ir_temps bt_temps dt_temps].map do |sym|
        pre_pad + boost_data.send(sym) + post_pad
      end
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
