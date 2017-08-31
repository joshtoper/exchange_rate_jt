require 'exchange_rate_jt/version'
require 'exchange_rate_jt/configuration'
require 'exchange_rate_jt/data_store_factory'
require 'exchange_rate_jt/rates_source_factory'

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

  def self.update_exchange_rates
    rates = RatesSourceFactory.build(configuration.source).fetch_rates
    DataStoreFactory
      .build(configuration.data_store_type, configuration.data_store)
      .persist_rates(rates)
  end
end
