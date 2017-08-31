require 'spec_helper'

module ExchangeRateJt
  RSpec.describe DataStoreFactory do
    
    describe '.build' do
      let(:pstore_connection_string) { double('PStore connection string') }
      let(:pstore) { double('PStore') }
      
      context 'with a valid type' do
        it 'returns a data store handler for the supplied type' do
          expect(PStore).to receive(:new).with(pstore_connection_string)
            .and_return pstore

          store = described_class.build(:pstore, pstore_connection_string)

          expect(store).to eq pstore
        end
      end

      context 'with an invalid type' do
        it 'raises an InvalidDataStoreTypeError' do
          expect { described_class.build(:blah, double) }
            .to raise_error InvalidDataStoreTypeError
        end
      end

      context 'with missing params' do
        it 'raises a ArgumentError' do
          expect { described_class.build }.to raise_error ArgumentError

          expect { described_class.build(:pstore) }.to raise_error ArgumentError
        end
      end
    end
  end
end
