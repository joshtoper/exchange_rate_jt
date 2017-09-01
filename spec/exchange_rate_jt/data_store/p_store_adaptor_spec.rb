require 'spec_helper'
require 'pstore'

module ExchangeRateJt
  module DataStore
    RSpec.describe PStoreAdaptor do
      describe '#new' do
        let(:connection_string) { double('Connection String') }
        let(:store) { described_class.new(connection_string) }

        it 'is initialized with the connection string' do
          expect(connection_string).to receive(:is_a?)
            .with(PStore).and_return true

          expect(store.data_store).to eq connection_string
        end

        it 'raises if the connection string is not a PStore' do
          expect(connection_string).to receive(:is_a?)
            .with(PStore).and_return false
          
          expect { described_class.new(connection_string) }
            .to raise_error InvalidConnectionTypeError
        end
      end

      describe '#persist' do
        let(:file_location) { File.expand_path(File.dirname(__FILE__) + '../../../support/store.test') }
        let(:connection_string) { PStore.new(file_location) }
        let(:store) { described_class.new(connection_string) }
        
        it 'persists the supplied exchange rate data' do
          store.persist(:aug_31_2017, { "USD" => "1.1825" })

          connection_string.transaction do
            expect(connection_string[:aug_31_2017]['USD']).to eq '1.1825'
          end
        end
      end

      describe '#fetch' do
        let(:file_location) { File.expand_path(File.dirname(__FILE__) + '../../../support/store.test') }
        let(:connection_string) { PStore.new(file_location) }
        let(:store) { described_class.new(connection_string) }

        before do
          store.persist(:aug_31_2017, { "USD" => "1.1825" })
        end

        context 'when the rate can be found' do
          it 'returns the rate' do
            expect(store.fetch(:aug_31_2017, 'USD')).to eq '1.1825'
          end
        end

        context 'when the rate cannot be found' do
          it 'raises a DataNotFoundError' do
            expect { store.fetch(:aug_31_2017, 'ABC') }
              .to raise_error DataNotFoundError
          end
        end
      end
    end
  end
end
