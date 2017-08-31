require 'pstore'

module ExchangeRateJt
  module DataStore
    class InvalidConnectionTypeError < StandardError; end
    class RateNotFoundError < StandardError; end

    class PStoreAdaptor
      attr_reader :data_store

      def initialize(data_store)
        unless data_store.is_a?(PStore)
          raise InvalidConnectionTypeError, 'Invalid connection type'
        end
        @data_store = data_store
      end

      def persist_rates(rates)
        data_store.transaction do
          rates.each do |date, values|
            data_store[date] = values
          end
          data_store.commit
        end
      end

      def fetch_rate(date, currency)
        return 1 if currency == 'EUR'
        rate = data_store.transaction { data_store[date][currency] }
        raise RateNotFoundError, 'Exchange rate not found' if rate.nil?
        rate.to_f
      end
    end
  end
end
