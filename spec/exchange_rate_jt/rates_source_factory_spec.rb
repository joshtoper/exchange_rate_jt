require 'spec_helper'

module ExchangeRateJt
  RSpec.describe RatesSourceFactory do
    describe '.build' do
      context 'with a valid source' do
        let(:ecb_source_instance) { double('EB source instance') }

        it 'returns a rates source object for the specified source' do
          expect(RatesSource::ECB).to receive(:new)
            .and_return ecb_source_instance

          expect(described_class.build(:ecb)).to eq ecb_source_instance
        end
      end
    end
  end
end
