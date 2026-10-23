# frozen_string_literal: true

RSpec.describe Prfl::BoostData do
  let(:path)              { Prfl.config.boost_path }
  let(:filename)          { "#{path}/test_7907.json" }
  let(:boost_data)        { described_class.new(filename) }
  let(:raw_boost_data)    { File.read(filename) }
  let(:parsed_boost_data) { JSON.parse(raw_boost_data) }

  context "when loading a Boost data file and creating a BoostData object" do
    it "stores the raw file" do
      expect(boost_data.source).to eq(raw_boost_data)
    end

    it "parses the raw file as JSON" do
      expect(boost_data.data).to eq(parsed_boost_data)
    end

    it "builds a timex array" do
      timex = JSON.parse(File.read("#{path}/timex.json"))
      expect(boost_data.timex).to eq(timex)
    end

    it "builds ir_temps" do
      ir_temps = JSON.parse(File.read("#{path}/ir_temps.json"))
      expect(boost_data.ir_temps).to eq(ir_temps)
    end

    it "builds bt_temps" do
      bt_temps = JSON.parse(File.read("#{path}/bt_temps.json"))
      expect(boost_data.bt_temps).to eq(bt_temps)
    end

    it "builds it_temps" do
      it_temps = JSON.parse(File.read("#{path}/it_temps.json"))
      expect(boost_data.it_temps).to eq(it_temps)
    end

    it "builds dt_temps" do
      dt_temps = JSON.parse(File.read("#{path}/dt_temps.json"))
      expect(boost_data.dt_temps).to eq(dt_temps)
    end

    it "derives ir_ror" do
      ir_ror = JSON.parse(File.read("#{path}/ir_ror.json"))
      expect(boost_data.ir_ror).to eq(ir_ror)
    end

    it "derives bt_ror" do
      bt_ror = JSON.parse(File.read("#{path}/bt_ror.json"))
      expect(boost_data.bt_ror).to eq(bt_ror)
    end

    it "derives it_ror" do
      it_ror = JSON.parse(File.read("#{path}/it_ror.json"))
      expect(boost_data.it_ror).to eq(it_ror)
    end

    it "derives dt_ror" do
      dt_ror = JSON.parse(File.read("#{path}/dt_ror.json"))
      expect(boost_data.dt_ror).to eq(dt_ror)
    end
  end
end
