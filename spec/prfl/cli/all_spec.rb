# frozen_string_literal: true

RSpec.describe Prfl::CLI::All do
  let(:all) { described_class.new({}) }

  let(:profiles) do
    [
      { "prflName" => "8034th roasting" },
      { "prflName" => "BI Kamthura" },
      { "prflName" => "Replication Profile: 8034th roasting" },
      { "prflName" => "Replication Profile: BI Kamthura" },
      { "prflName" => "7885 Decaf Fortune" },
      { "prflName" => "Replication Profile: 7885 Decaf Fortune" },
      { "prflName" => "7890 Replication Profile: 7885 Decaf Fortune" },
      { "prflName" => "Decaf Fortune" },
      { "prflName" => "Replication Profile: Decaf Fortune" },
      { "prflName" => "7890 Replication Profile: Decaf Fortune" }
    ]
  end

  let(:filtered_profiles) do
    [
      { "prflName" => "7885 Decaf Fortune" },
      { "prflName" => "Replication Profile: 7885 Decaf Fortune" },
      { "prflName" => "7890 Replication Profile: 7885 Decaf Fortune" },
      { "prflName" => "Decaf Fortune" },
      { "prflName" => "Replication Profile: Decaf Fortune" },
      { "prflName" => "7890 Replication Profile: Decaf Fortune" }
    ]
  end

  context "when detecting Onyx Tonics' roast names" do
    it "matches a manual roast without a customized name" do
      expect(all.match_onyx_tonics?("8034th roasting")).to be true
    end

    it "matches a replication of a roast without a customized name" do
      expect(all.match_onyx_tonics?("Replication Profile: 8034th roasting")).to be true
    end

    it "matches a manual roast with a 'BI' prefix" do
      expect(all.match_onyx_tonics?("BI Kamthura")).to be true
    end

    it "matches a manual roast with a 'bi' prefix" do
      expect(all.match_onyx_tonics?("bi Kamthura")).to be true
    end

    it "matches a replication of a roast with a 'BI' prefix" do
      expect(all.match_onyx_tonics?("Replication Profile: BI Kamthura")).to be true
    end

    it "matches a replication of a roast with a 'bi' prefix" do
      expect(all.match_onyx_tonics?("Replication Profile: bi Kamthura")).to be true
    end
  end

  context "when detecting Carrier Roasting's roast names" do
    it "matches a manual roast with a leading batch number" do
      expect(all.match_onyx_tonics?("7885 Decaf Fortune")).to be false
    end

    it "matches a manual roast without a leading batch number" do
      expect(all.match_onyx_tonics?("Decaf Fortune")).to be false
    end

    it "matches a non-numbered replication of a numbered roast" do
      expect(all.match_onyx_tonics?("Replication Profile: 7885 Decaf Fortune")).to be false
    end

    it "matches a numbered replication of a numbered roast" do
      expect(all.match_onyx_tonics?("7890 Replication Profile: 7885 Decaf Fortune")).to be false
    end

    it "matches a non-numbered replicaton of a non-numbered roast" do
      expect(all.match_onyx_tonics?("Replication Profile: Decaf Fortune")).to be false
    end

    it "matches a numbered replication of a non-numbered roast" do
      expect(all.match_onyx_tonics?("7890 Replication Profile: Decaf Fortune")).to be false
    end
  end

  it "filters profiles by name" do
    all.profiles = profiles
    all.filter_profiles
    expect(all.profiles).to eq filtered_profiles
  end
end
