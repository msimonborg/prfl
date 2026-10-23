# frozen_string_literal: true

RSpec.describe Prfl do
  it "has a version number" do
    expect(Prfl::VERSION).not_to be_nil
  end

  it "has a config" do
    expect(described_class.config).to be_a Prfl::Config
  end

  it "loads the configuration from `./config.rb`" do
    expect(described_class.config.boost_email).to eq ENV.fetch("PRFL_BOOST_EMAIL", nil)
  end

  it "can update the config with block syntax" do
    artisan_path = described_class.config.artisan_path
    described_class.config { |config| config.artisan_path = "Banana" }
    expect(described_class.config.artisan_path).to be "Banana"

    # Clean up
    described_class.config { |config| config.artisan_path = artisan_path }
  end

  it "can update the config without block syntax" do
    artisan_path = described_class.config.artisan_path
    described_class.config.artisan_path = "Banana"
    expect(described_class.config.artisan_path).to be "Banana"

    # Clean up
    described_class.config.artisan_path = artisan_path
  end
end
