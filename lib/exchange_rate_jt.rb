require "exchange_rate_jt/version"
require 'exchange_rate_jt/configuration'

module ExchangeRateJt
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
