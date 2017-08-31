require 'exchange_rate_jt/version'
require 'exchange_rate_jt/configuration'
require 'exchange_rate_jt/data_store_factory'
require 'exchange_rate_jt/rates_source_factory'

module ExchangeRateJt
  class LookupError < StandardError; end
  class UpdateError < StandardError; end
  class InvalidDateError < StandardError; end
  class NoExchangeRateDataError < StandardError; end

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
  rescue => exception
    raise UpdateError, exception.message
  end

  class << self
    def at(date, base, counter)
      validate_date(date)
      date = date.strftime('%b_%d_%Y').to_sym.downcase

      data_store = DataStoreFactory
                   .build(configuration.data_store_type,
                          configuration.data_store)

      base = data_store.fetch_rate(date, base)
      counter = data_store.fetch_rate(date, counter)

      rate = counter / base

      { status: :success, rate: rate }
    rescue => exception
      raise LookupError, exception.message
    end

    private

    def validate_date(date)
      raise InvalidDateError, 'Invalid date specified' unless date.is_a?(Date)
      raise InvalidDateError, 'Invalid date specified' if date > Date.today
    end
  end
end
