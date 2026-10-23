# frozen_string_literal: true

module Prfl
  class BoostDataTestHelper
    def path
      @path ||= Prfl.config.boost_path
    end

    def filename
      @filename ||= "#{path}/test_7907.json"
    end

    def raw_boost_data
      @raw_boost_data ||= File.read(filename)
    end

    def parsed_boost_data
      @parsed_boost_data ||= JSON.parse(raw_boost_data)
    end

    def temps
      (0..15).to_a
    end
  end
end

RSpec.describe Prfl::BoostData do
  let(:test_helper)       { Prfl::BoostDataTestHelper.new }
  let(:boost_data)        { described_class.new(test_helper.filename) }

  context "when loading a Boost data file and creating a BoostData object" do
    it "stores the raw file" do
      expect(boost_data.source).to eq(test_helper.raw_boost_data)
    end

    it "parses the raw file as JSON" do
      expect(boost_data.data).to eq(test_helper.parsed_boost_data)
    end

    it "builds a timex array" do
      timex = JSON.parse(File.read("#{test_helper.path}/timex.json"))
      expect(boost_data.timex).to eq(timex)
    end

    it "builds ir_temps" do
      ir_temps = JSON.parse(File.read("#{test_helper.path}/ir_temps.json"))
      expect(boost_data.ir_temps).to eq(ir_temps)
    end

    it "builds bt_temps" do
      bt_temps = JSON.parse(File.read("#{test_helper.path}/bt_temps.json"))
      expect(boost_data.bt_temps).to eq(bt_temps)
    end

    it "builds it_temps" do
      it_temps = JSON.parse(File.read("#{test_helper.path}/it_temps.json"))
      expect(boost_data.it_temps).to eq(it_temps)
    end

    it "builds dt_temps" do
      dt_temps = JSON.parse(File.read("#{test_helper.path}/dt_temps.json"))
      expect(boost_data.dt_temps).to eq(dt_temps)
    end

    it "derives ir_ror" do
      ir_ror = JSON.parse(File.read("#{test_helper.path}/ir_ror.json"))
      expect(boost_data.ir_ror).to eq(ir_ror)
    end

    it "derives bt_ror" do
      bt_ror = JSON.parse(File.read("#{test_helper.path}/bt_ror.json"))
      expect(boost_data.bt_ror).to eq(bt_ror)
    end

    it "derives it_ror" do
      it_ror = JSON.parse(File.read("#{test_helper.path}/it_ror.json"))
      expect(boost_data.it_ror).to eq(it_ror)
    end

    it "derives dt_ror" do
      dt_ror = JSON.parse(File.read("#{test_helper.path}/dt_ror.json"))
      expect(boost_data.dt_ror).to eq(dt_ror)
    end
  end

  context "when calculating the rate of rise" do
    it "determines the rate of rise for an index >= 15 in a temperature array" do
      temps = test_helper.temps
      factor = 4.0
      index = 15
      ror = boost_data.send(:calculate_ror_datapoint, temps, factor, index)
      expect(ror).to eq(60.0)
    end

    it "returns -1.0 for an index < 15 in a temperature array" do
      temps = test_helper.temps
      factor = 4.0
      index = 14
      ror = boost_data.send(:calculate_ror_datapoint, temps, factor, index)
      expect(ror).to eq(-1.0)
    end

    it "determines the correct factor for the IR sensor" do
      factor = boost_data.send(:determine_ror_factor, :ir)
      expect(factor).to eq(4.0)
    end

    it "determines the correct factor for the BT sensor" do
      factor = boost_data.send(:determine_ror_factor, :bt)
      expect(factor).to eq(4.0)
    end

    it "determines the correct factor for the IT sensor" do
      factor = boost_data.send(:determine_ror_factor, :it)
      expect(factor).to eq(10.0 / 15.0)
    end

    it "determines the correct factor for the DT sensor" do
      factor = boost_data.send(:determine_ror_factor, :dt)
      expect(factor).to eq(4.0)
    end
  end
end
