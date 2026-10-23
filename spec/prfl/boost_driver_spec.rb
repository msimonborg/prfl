# frozen_string_literal: true

RSpec.describe Prfl::BoostDriver do
  let(:driver) { described_class.new }

  it "creates a Selenium web driver" do
    driver.create_driver
    expect(driver.driver).to be_a Selenium::WebDriver::Chrome::Driver
  end

  context "when quitting the Selenium web driver" do
    it "status is 'ready' before quitting" do
      driver.create_driver
      expect(driver.driver.status["ready"]).to be true
    end

    it "#quit shuts down the driver" do
      driver.create_driver
      driver.quit
      expect { driver.driver.status }.to raise_error(Errno::ECONNREFUSED)
    end
  end
end
