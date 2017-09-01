module ExchangeRateJt
  class Configuration
    attr_accessor :data_store, :data_store_type, :source, :default_currency

    def initialize
      @data_store = nil
      @data_store_type = nil
      @source = nil
      @default_currency = nil
    end
  end
end
