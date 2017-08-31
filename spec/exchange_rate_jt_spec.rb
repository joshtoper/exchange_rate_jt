require "spec_helper"

RSpec.describe ExchangeRateJt do
  it "has a version number" do
    expect(ExchangeRateJt::VERSION).not_to be nil
  end

  describe '.configure' do
    let(:pstore) { double('Pstore') }
    before do
      ExchangeRateJt.configure do |config|
        config.source = :ecb
        config.cache_type = :pstore
        config.cache_store = pstore
      end
    end

    it 'is externally configurable' do
      config = ExchangeRateJt.configuration
      
      expect(config.source).to eq :ecb
      expect(config.cache_type).to eq :pstore
      expect(config.cache_store).to eq pstore
    end
  end
end
