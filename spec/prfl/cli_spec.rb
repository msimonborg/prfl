# frozen_string_literal: true

RSpec.describe Prfl::CLI do
  let(:opts) { { list: %w[1234 5678], no_merge: true } }
  let(:cli) { described_class.new(opts) }

  context "when initializing a new instance" do
    it "stores the options" do
      expect(cli.opts).to eq(opts)
    end

    it "reads the config" do
      expect(cli.config).to eq(Prfl.config)
    end

    it "sets the boost directory" do
      expect(cli.boost_dir.to_path).to eq(Prfl.config.boost_path)
    end

    it "sets the artisan directory" do
      expect(cli.artisan_dir.to_path).to eq(Prfl.config.artisan_path)
    end

    it "sets the target directory" do
      expect(cli.target_dir.to_path).to eq(Prfl.config.target_path)
    end
  end

  context "when instantiating subprograms" do
    it "instantiates the All subprogram" do
      expect(cli.all).to be_a(Prfl::CLI::All)
    end

    it "passes the options to the All subprogram" do
      expect(cli.all.opts).to eq(opts)
    end

    it "instantiates the List subprogram" do
      expect(cli.list).to be_a(Prfl::CLI::List)
    end

    it "passes the options to the List subprogram" do
      expect(cli.list.opts).to eq(opts)
    end

    it "instantiates the Merge subprogram" do
      expect(cli.merge).to be_a(Prfl::CLI::Merge)
    end

    it "passes the options to the Merge subprogram" do
      expect(cli.merge.opts).to eq(opts)
    end
  end

  context "when using the Driver" do
    let(:driver) { instance_double(Prfl::BoostDriver) }
    let(:response) { '{"totalRstCnt": 42, "profiles": []}' }

    before do
      allow(driver).to receive(:new_session)
      allow(driver).to receive(:get_profile_metadata).and_return(response)
      cli.new_boost_session(driver)
      cli.get_profile_metadata
    end

    it "#new_boost_session receives the driver and calls new_session" do
      expect(driver).to have_received(:new_session)
    end

    it "stores the driver" do
      expect(cli.driver).to eq(driver)
    end

    it "calls get_profile_metadata on the driver" do
      expect(driver).to have_received(:get_profile_metadata)
    end

    it "stores the response" do
      expect(cli.response).to be response
    end

    it "parses and stores the profile metadata" do
      expect(cli.profile_metadata).to eq(JSON.parse(response))
    end

    it "stores the total roast count" do
      expect(cli.total_roast_count).to be 42
    end
  end

  context "when parsing the profile metadata" do
    let(:profiles) do
      [{ "prflName" => "12345 Roast", "prflMCd" => "long_id" },
       { "prflName" => "5678 Roast", "prflMCd" => "another_id" },
       { "prflName" => "No Batch Number", "prflMCd" => "no_batch_id" },
       { "prflName" => "Wrong batch number location 9876", "prflMCd" => "wrong_location_id" }]
    end

    let(:expected_filenames) do
      ["long_id_12345.json", "another_id_5678.json", "no_batch_id.json", "wrong_location_id.json"].sort
    end

    let(:fetch_list) do
      [{ id: "long_id", filename: "long_id_12345.json" },
       { id: "another_id", filename: "another_id_5678.json" },
       { id: "no_batch_id", filename: "no_batch_id.json" },
       { id: "wrong_location_id", filename: "wrong_location_id.json" }]
    end

    it "extracts the batch number from a profile name" do
      batch_nums = profiles.map { |profile| cli.extract_batch_num(profile) }.sort
      expect(batch_nums).to eq(["", "", "12345", "5678"])
    end

    it "adds filenames to the profiles" do
      profiles.each { |profile| cli.add_filename(profile) }
      filenames = profiles.map { |profile| profile["filename"] }.sort
      expect(filenames).to eq(expected_filenames)
    end

    it "builds a fetch list of profiles with IDs and filenames" do
      profiles.each { |profile| cli.add_filename(profile) }
      cli.profiles = profiles
      cli.build_fetch_list

      expect(cli.fetch_list).to eq(fetch_list)
    end
  end
end
