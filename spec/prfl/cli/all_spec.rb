# frozen_string_literal: true

RSpec.describe Prfl::CLI::All do
  it "detects Onyx Tonics' roast names" do
    all = Prfl::CLI::All.new({})

    expect(all.match_onyx_tonics?("8034th roasting")).to be true
    expect(all.match_onyx_tonics?("BI Kamthura")).to be true
    expect(all.match_onyx_tonics?("Replication Profile: 8034th roasting")).to be true
    expect(all.match_onyx_tonics?("Replication Profile: BI Kamthura")).to be true
  end

  it "detects Carrier Roasting's roast names" do
    all = Prfl::CLI::All.new({})

    expect(all.match_onyx_tonics?("7885 Decaf Fortune")).to be false
    expect(all.match_onyx_tonics?("Replication Profile: 7885 Decaf Fortune")).to be false
    expect(all.match_onyx_tonics?("7890 Replication Profile: 7885 Decaf Fortune")).to be false
    expect(all.match_onyx_tonics?("Decaf Fortune")).to be false
    expect(all.match_onyx_tonics?("Replication Profile: Decaf Fortune")).to be false
    expect(all.match_onyx_tonics?("7890 Replication Profile: Decaf Fortune")).to be false
  end

  it "filters profiles by name" do
    profiles = [
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

    filtered_profiles = [
      { "prflName" => "7885 Decaf Fortune" },
      { "prflName" => "Replication Profile: 7885 Decaf Fortune" },
      { "prflName" => "7890 Replication Profile: 7885 Decaf Fortune" },
      { "prflName" => "Decaf Fortune" },
      { "prflName" => "Replication Profile: Decaf Fortune" },
      { "prflName" => "7890 Replication Profile: Decaf Fortune" }
    ]

    all = Prfl::CLI::All.new({})

    all.profiles = profiles
    expect(all.profiles).not_to eq(filtered_profiles)

    all.filter_profiles
    expect(all.profiles).to eq(filtered_profiles)
  end
end
