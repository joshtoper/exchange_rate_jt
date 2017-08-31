require_relative 'data_store/p_store_adaptor'

module ExchangeRateJt
  class InvalidDataStoreTypeError < StandardError; end

  # DataStoreFactory builds and returns an instance of the
  # appropriate data store handler for the defined data store type
  class DataStoreFactory
    MAPS = { pstore: DataStore::PStoreAdaptor }.freeze
    
    def self.build(data_store_type, data_store)
      MAPS[data_store_type].new(data_store)
    rescue
      raise InvalidDataStoreTypeError, 
            'Invalid or no data store type specified'
    end
  end
end
