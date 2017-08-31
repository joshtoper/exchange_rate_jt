require "spec_helper"

RSpec.describe ExchangeRateJt do
  let(:pstore_connection_string) { double('PStore connection string') }

  it 'has a version number' do
    expect(ExchangeRateJt::VERSION).not_to be nil
  end

  describe '.configure' do
    before do
      setup_config
    end

    it 'allows the gem to be configured by the client' do
      config = ExchangeRateJt.configuration
      
      expect(config.source).to eq :ecb
      expect(config.data_store_type).to eq :pstore
      expect(config.data_store).to eq pstore_connection_string
    end
  end

  describe '.update_exchange_rates' do
    let(:rates) { double('Obtained rates') }
    let(:rates_source) { double('Rates source') }
    let(:pstore_instance) { double('PStore instance') }

    before do
      setup_config
    end

    it 'fetches and persists the latest exchange rates from the specified source' do
      expect(ExchangeRateJt::RatesSourceFactory)
        .to receive(:build).with(:ecb).and_return rates_source
      
      expect(rates_source).to receive(:fetch_rates).and_return rates
      
      expect(ExchangeRateJt::DataStoreFactory).to receive(:build)
        .with(:pstore, pstore_connection_string)
        .and_return pstore_instance
      
      expect(pstore_instance).to receive(:persist_rates).with(rates)
        .and_return true

      ExchangeRateJt.update_exchange_rates
    end
  end

  private

  def setup_config
    ExchangeRateJt.configure do |config|
      config.source = :ecb
      config.data_store_type = :pstore
      config.data_store = pstore_connection_string
    end
  end
end
