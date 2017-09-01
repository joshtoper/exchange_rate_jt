require 'bigdecimal'

module ExchangeRateJt
  class LookupError < StandardError; end
  class UpdateError < StandardError; end
  class InvalidDateError < StandardError; end
  class FutureDateError < StandardError; end
  class NoExchangeRateDataError < StandardError; end
  class RateNotFoundError < StandardError; end

  class ExchangeRates
    def initialize(configuration)
      @configuration = configuration
    end

    def update
      rates = RatesSourceFactory.build(configuration.source).fetch_rates
      rates.each { |date, values| data_store.persist(date, values) }
      true
    rescue => exception
      raise UpdateError, exception.message
    end

    def at(date, base, counter)
      validate_date(date)
      date = date.strftime('%b_%d_%Y').to_sym.downcase

      base = fetch_rate(date, base)
      counter = fetch_rate(date, counter)

      rate = counter / base

      { status: :success, rate: BigDecimal.new(rate, 5) }
    end

    private

    attr_reader :configuration

    def data_store
      @data_store ||= build_data_store
    end

    def build_data_store
      DataStoreFactory
        .build(configuration.data_store_type, configuration.data_store)
    end

    def fetch_rate(date, currency)
      return 1 if currency.to_s == configuration.default_currency.to_s
      data_store.fetch(date, currency)
    rescue DataStore::DataNotFoundError
      raise RateNotFoundError, 'Exchange rate data not found'
    end

    def validate_date(date)
      raise InvalidDateError, 'Invalid date specified' unless date.is_a?(Date)
      raise FutureDateError, 'Date cannot be in the future' if date > Date.today
    end
  end
end
