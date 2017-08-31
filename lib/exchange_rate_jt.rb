require "exchange_rate_jt/version"
require 'exchange_rate_jt/configuration'
require 'exchange_rate_jt/data_store_factory'

module ExchangeRateJt
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
