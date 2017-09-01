require 'spec_helper'
module ExchangeRateJt
  RSpec.describe ExchangeRates do
    let(:configuration) { double('Configuration') }
    let(:exchange_rates) { described_class.new(configuration) }

    before do
      allow(configuration).to receive(:source).and_return :ecb
      allow(configuration).to receive(:data_store_type).and_return :shoe
      allow(configuration).to receive(:data_store).and_return :some_connection
    end

    describe '#update' do
      let(:rates_source) { double('Rates source') }
      let(:pstore_instance) { double('PStore instance') }

      context 'when the rates can be fetched' do

        it 'fetches and persists the latest exchange rates from the specified source' do
          expect(ExchangeRateJt::RatesSourceFactory)
            .to receive(:build).with(:ecb).and_return rates_source

          expect(rates_source).to receive(:fetch_rates).and_return rates

          expect(ExchangeRateJt::DataStoreFactory).to receive(:build)
            .with(:shoe, :some_connection)
            .and_return pstore_instance

          expect(pstore_instance).to receive(:persist).with(:foo, :bar)
          expect(pstore_instance).to receive(:persist).with(:hello, :goodbye)

          expect(exchange_rates.update).to eq true
        end
      end

      context 'when the rates cannot be fetched' do
        it 'raises an UpdateError' do
          expect(ExchangeRateJt::RatesSourceFactory)
            .to receive(:build).with(:ecb).and_return rates_source

          expect(rates_source).to receive(:fetch_rates)
            .and_raise StandardError, 'Something went wrong'

          expect { exchange_rates.update }
            .to raise_error UpdateError, 'Something went wrong'
        end
      end
    end

    describe '#at' do
      let(:pstore_instance) { double('PStore instance') }

      context 'with valid params' do
        before do
          allow(Date).to receive(:today).and_return Date.new(2017, 8, 31)
          allow(configuration).to receive(:default_currency).and_return 'EUR'
        end

        it 'retrieves the requested information in hash format' do
          expect(ExchangeRateJt::DataStoreFactory).to receive(:build)
            .with(:shoe, :some_connection).and_return pstore_instance

          expect(pstore_instance).to receive(:fetch)
            .with(:aug_31_2017, 'GBP').and_return 1
          expect(pstore_instance).to receive(:fetch)
            .with(:aug_31_2017, 'USD').and_return 1.5

          result = exchange_rates.at(Date.today, 'GBP', 'USD')

          expect(result).to eq(status: :success, rate: 1.5)
        end
      end

      context 'when one of the currencies specified is the default' do
        before do
          allow(configuration).to receive(:default_currency).and_return 'EUR'
          allow(Date).to receive(:today).and_return Date.new(2017, 8, 31)
        end

        it 'returns 1 for the default currency' do
          expect(ExchangeRateJt::DataStoreFactory).to receive(:build)
            .with(:shoe, :some_connection).and_return pstore_instance

          expect(pstore_instance).to receive(:fetch)
            .with(:aug_31_2017, 'USD').and_return 1.5

          result = exchange_rates.at(Date.today, 'EUR', 'USD')

          expect(result).to eq(status: :success, rate: 1.5)
        end
      end

      context 'when the date is invalid' do
        it 'raises an InvalidDateError' do
          expect { exchange_rates.at('wibble', 'GBP', 'USD') }
            .to raise_error InvalidDateError
        end
      end

      context 'when the date is in the future' do
        let(:future_date) { Date.new(2050, 8, 31) }

        before do
          allow(Date).to receive(:today).and_return(Date.new(2017, 1, 1))
        end

        it 'raises a LookupError' do
          expect { exchange_rates.at(future_date, 'GBP', 'USD') }
            .to raise_error FutureDateError
        end
      end

      context 'when the exchange rate data cannot be fetched' do
        let(:pstore_instance) { double('PStore instance') }

        before do
          allow(configuration).to receive(:default_currency).and_return 'EUR'
          allow(Date).to receive(:today).and_return(Date.new(2017, 1, 1))
        end

        it 'raises a LookupError' do
          expect(ExchangeRateJt::DataStoreFactory).to receive(:build)
            .with(:shoe, :some_connection).and_return pstore_instance
          expect(pstore_instance).to receive(:fetch)
            .with(:jan_01_2017, 'GBP').and_return 1
          expect(pstore_instance).to receive(:fetch)
            .with(:jan_01_2017, 'USD').and_raise DataStore::DataNotFoundError

          expect { exchange_rates.at(Date.today, 'GBP', 'USD') }
            .to raise_error RateNotFoundError
        end
      end


    end

    private

    def rates
      {
        foo: :bar,
        hello: :goodbye
      }
    end
  end
end
