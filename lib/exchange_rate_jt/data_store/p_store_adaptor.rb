require 'pstore'

module ExchangeRateJt
  module DataStore
    class InvalidConnectionTypeError < StandardError; end

    class PStoreAdaptor
      attr_reader :data_store

      def initialize(data_store)
        raise InvalidConnectionTypeError unless data_store.is_a?(PStore)
        @data_store = data_store
      end

      def persist_rates(rates)
        data_store.transaction do
          rates.each do |date, values|
            data_store[date] = values
          end
        end
      end
    end
  end
end
