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

  private

  def setup_config
    ExchangeRateJt.configure do |config|
      config.source = :ecb
      config.data_store_type = :pstore
      config.data_store = pstore_connection_string
      config.default_currency = :EUR
    end
  end
end
