require 'pstore'

module ExchangeRateJt
  module DataStore
    class InvalidConnectionTypeError < StandardError; end
    class DataNotFoundError < StandardError; end

    class PStoreAdaptor
      attr_reader :data_store

      def initialize(data_store)
        unless data_store.is_a?(PStore)
          raise InvalidConnectionTypeError, 'Invalid connection type'
        end
        @data_store = data_store
      end

      def persist(key, value)
        data_store.transaction do
          data_store[key] = value
          data_store.commit
        end
      end

      def fetch(key, value)
        data = data_store.transaction { data_store[key][value] }
        raise DataNotFoundError, 'Data not found' if data.nil?
        data
      rescue
        raise DataNotFoundError, 'Data not found'
      end
    end
  end
end
