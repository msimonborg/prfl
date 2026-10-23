# frozen_string_literal: true

RSpec.describe Prfl::ArtisanData do
  let(:raw_filename)        { "#{Prfl.config.artisan_path}/test #7907 test.alog" }
  let(:artisan_data)        { described_class.new(raw_filename) }
  let(:raw_artisan_data)    { File.read(raw_filename) }
  let(:parsed_artisan_data) { JSON.parse(File.read("#{Prfl.config.artisan_path}/parsed #7907 test.json")) }
  let(:merged_filename)     { "#{Prfl.config.target_path}/test #7907 test.alog" }

  context "when loading an Artisan data file and creating an ArtisanData object" do
    it "stores the raw file" do
      expect(artisan_data.source).to eq(raw_artisan_data)
    end

    it "parses the raw file as JSON" do
      expect(artisan_data.data).to eq(parsed_artisan_data)
    end

    it "sets the drop index" do
      expect(artisan_data.drop_index).to be(parsed_artisan_data["timeindex"][6])
    end

    it "calibrates the BT if it receives the calibrate: true option" do
      calibrated_artisan_data = described_class.new(raw_filename, calibrate: true)
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
      boost_data = Prfl::BoostData.new("#{Prfl.config.boost_path}/test_7907.json")
      merged_artisan_data = described_class.new(merged_filename)
      artisan_data.merge_boost!(boost_data)

      expect(artisan_data.data).to eq(merged_artisan_data.data)
    end

    it "converts the data back to raw .alog format" do
      boost_data = Prfl::BoostData.new("#{Prfl.config.boost_path}/test_7907.json")
      artisan_data.merge_boost!(boost_data)

      expect(artisan_data.convert_to_raw).to eq(File.read(merged_filename))
    end
  end
end
