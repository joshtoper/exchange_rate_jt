require_relative 'p_store'

module ExchangeRateJt
  class InvalidDataStoreTypeError < StandardError; end

  # DataStoreFactory builds and returns an instance of the
  # appropriate data store handler for the defined data store type
  class DataStoreFactory
    MAPS = { pstore: PStore }.freeze
    
    def self.build(data_store_type, data_store)
      MAPS[data_store_type].new(data_store)
    rescue
      raise InvalidDataStoreTypeError
    end
  end
end
