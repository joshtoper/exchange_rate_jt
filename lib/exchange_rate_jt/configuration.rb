module ExchangeRateJt
  class Configuration
    attr_accessor :cache_store, :cache_type, :source

    def initialize
      @cache_store = nil
      @cache_type = nil
      @source = nil
    end
  end
end
