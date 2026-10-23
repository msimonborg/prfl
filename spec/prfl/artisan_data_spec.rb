# frozen_string_literal: true

module Prfl
  # Helper class for testing the ArtisanData class
  class ArtisanDataTestHelper
    def raw_filename
      @raw_filename ||= "#{Prfl.config.artisan_path}/test #7907 test.alog"
    end

    def raw_artisan_data
      @raw_artisan_data ||= File.read(raw_filename)
    end

    def parsed_artisan_data
      @parsed_artisan_data ||= JSON.parse(File.read("#{Prfl.config.artisan_path}/parsed #7907 test.json"))
    end

    def merged_filename
      @merged_filename ||= "#{Prfl.config.target_path}/test #7907 test.alog"
    end

    def boost_filename
      @boost_filename ||= "#{Prfl.config.boost_path}/test_7907.json"
    end
  end
end

RSpec.describe Prfl::ArtisanData do
  let(:artisan_data) { described_class.new(test_helper.raw_filename) }
  let(:test_helper)  { Prfl::ArtisanDataTestHelper.new }

  context "when loading an Artisan data file and creating an ArtisanData object" do
    it "stores the raw file" do
      expect(artisan_data.source).to eq(test_helper.raw_artisan_data)
    end

    it "parses the raw file as JSON" do
      expect(artisan_data.data).to eq(test_helper.parsed_artisan_data)
    end

    it "sets the drop index" do
      expect(artisan_data.drop_index).to be(test_helper.parsed_artisan_data["timeindex"][6])
    end

    it "calibrates the BT if it receives the calibrate: true option" do
      calibrated_artisan_data = described_class.new(test_helper.raw_filename, calibrate: true)
      calibrated_bt = JSON.parse(File.read("#{Prfl.config.artisan_path}/calibrated_bt.json"))
      expect(calibrated_artisan_data.data["temp2"]).to eq(calibrated_bt)
    end

    it "does not calibrate the BT if it does not recieve the calibrate: true option" do
      uncalibrated_bt = JSON.parse(File.read("#{Prfl.config.artisan_path}/uncalibrated_bt.json"))
      expect(artisan_data.data["temp2"]).to eq(uncalibrated_bt)
    end
  end

  context "when merging with a BoostData object" do
    it "correctly merges the profile data" do
      boost_data = Prfl::BoostData.new(test_helper.boost_filename)
      merged_artisan_data = described_class.new(test_helper.merged_filename)
      artisan_data.merge_boost!(boost_data)

      expect(artisan_data.data).to eq(merged_artisan_data.data)
    end

    it "converts the data back to raw .alog format" do
      boost_data = Prfl::BoostData.new(test_helper.boost_filename)
      artisan_data.merge_boost!(boost_data)

      expect(artisan_data.convert_to_raw).to eq(File.read(test_helper.merged_filename))
    end
  end
end
