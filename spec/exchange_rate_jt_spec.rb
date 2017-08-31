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

  describe '.at' do
    let(:data_store) { double('Data store') }

    before do
      setup_config
    end
    
    context 'with valid params' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2017, 8, 31)
      end

      it 'retrieves the requested information in hash format' do
        expect(ExchangeRateJt::DataStoreFactory).to receive(:build)
          .with(:pstore, pstore_connection_string).and_return data_store
        expect(data_store).to receive(:fetch_rate)
          .with(:aug_31_2017, 'GBP').and_return 1
        expect(data_store).to receive(:fetch_rate)
          .with(:aug_31_2017, 'USD').and_return 1.5

        result = described_class.at(Date.today, 'GBP', 'USD')

        expect(result).to eq(status: :success, rate: 1.5)
      end
    end

    context 'when the date is invalid' do
      it 'raises a LookupError' do
        expect { described_class.at('wibble', 'GBP', 'USD') }
          .to raise_error ExchangeRateJt::LookupError
      end
    end

    context 'when the date is in the future' do
      let(:future_date) { Date.new(2050, 8, 31) }

      before do
        allow(Date).to receive(:today).and_return(Date.new(2017, 1, 1))
      end

      it 'raises a LookupError' do
        expect { described_class.at(future_date, 'GBP', 'USD') }
          .to raise_error ExchangeRateJt::LookupError
      end
    end

    context 'when the exchange rate data cannot be fetched' do
      before do
        allow(Date).to receive(:today).and_return(Date.new(2017, 1, 1))
      end

      it 'raises a LookupError' do
        expect(ExchangeRateJt::DataStoreFactory).to receive(:build)
          .with(:pstore, pstore_connection_string).and_return data_store
        expect(data_store).to receive(:fetch_rate)
          .with(:jan_01_2017, 'GBP').and_return 1
        expect(data_store).to receive(:fetch_rate)
          .with(:jan_01_2017, 'USD').and_return nil

        expect { described_class.at(Date.today, 'GBP', 'USD') }
          .to raise_error ExchangeRateJt::LookupError
      end
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
