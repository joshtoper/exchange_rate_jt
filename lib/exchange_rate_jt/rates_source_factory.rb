require_relative 'rates_source/ecb'

module ExchangeRateJt
  class RatesSourceFactory
    MAPS = { ecb: RatesSource::ECB }.freeze
    
    def self.build(source)
      MAPS[source].new
    end
  end
end
