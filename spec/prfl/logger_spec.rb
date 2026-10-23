# frozen_string_literal: true

module Prfl
  class LoggerTest
    include Prfl::Logger
  end
end

RSpec.describe Prfl::Logger do
  let(:logger) { Prfl::LoggerTest.new }

  it "adds #log and #time_stamp instance methods when included" do
    expect(logger.respond_to?(:log) && logger.respond_to?(:time_stamp)).to be true
  end

  it "creates formatted timestamps" do
    format = /\[ \d{2}:\d{2}:\d{2}.\d{3} \]/
    expect(logger.time_stamp).to match format
  end
end
