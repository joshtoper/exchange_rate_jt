require 'exchange_rate_jt/version'
require 'exchange_rate_jt/configuration'
require 'exchange_rate_jt/exchange_rates'
require 'exchange_rate_jt/data_store_factory'
require 'exchange_rate_jt/rates_source_factory'

module ExchangeRateJt
  class << self
    attr_accessor :configuration
    attr_accessor :exchange_rates
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.exchange_rates
    @exchange_rates ||= ExchangeRates.new(configuration)
  end

  def self.configure
    yield(configuration)
  end

  def self.update_exchange_rates
    exchange_rates.update
  end

  def self.at(date, base, counter)
    exchange_rates.at(date, base, counter)
  end

  def self.currency_list
    exchange_rates.currency_list
  end
end
