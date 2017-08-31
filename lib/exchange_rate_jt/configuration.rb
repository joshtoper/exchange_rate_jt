module ExchangeRateJt
  class Configuration
    attr_accessor :data_store, :data_store_type, :source

    def initialize
      @data_store = nil
      @data_store_type = nil
      @source = nil
    end
  end
end
