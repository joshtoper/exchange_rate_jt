require 'spec_helper'

module ExchangeRateJt
  module RatesSource
    RSpec.describe ECB do
      let(:ecb) { described_class.new }
      let(:doc_path) { File.expand_path(File.dirname(__FILE__) + '../../../support/ecb.xml') }
      
      describe '#fetch_rates' do
        before do
          stub_const('ExchangeRateJt::RatesSource::ECB::REPOSITORY_URL', doc_path)
        end

        context 'when the rates can be fetched' do
          it 'returns the rates in a hash format' do
            expect(ecb.fetch_rates).to eq data_as_hash
          end
        end
      end

      describe '#currency_list' do
        before do
          stub_const('ExchangeRateJt::RatesSource::ECB::CURRENCY_LIST', currency_list)
        end
        
        it 'returns the currency list' do
          expect(ecb.currency_list).to eq currency_list
        end
      end

      private

      def data_as_hash
        { :aug_31_2017=>{ "USD"=>"1.1825", "JPY"=>"130.81", "BGN"=>"1.9558", "CZK"=>"26.101", "DKK"=>"7.4384", "GBP"=>"0.91973", "HUF"=>"306.63", "PLN"=>"4.2582", "RON"=>"4.5924", "SEK"=>"9.4818", "CHF"=>"1.1446", "NOK"=>"9.279", "HRK"=>"7.4148", "RUB"=>"69.1235", "TRY"=>"4.1063", "AUD"=>"1.5016", "BRL"=>"3.741", "CAD"=>"1.497", "CNY"=>"7.8059", "HKD"=>"9.2526", "IDR"=>"15782.1", "ILS"=>"4.2552", "INR"=>"75.5995", "KRW"=>"1331.22", "MXN"=>"21.0843", "MYR"=>"5.0506", "NZD"=>"1.6571", "PHP"=>"60.587", "SGD"=>"1.6094", "THB"=>"39.247", "ZAR"=>"15.4568"}, :aug_30_2017=>{"USD"=>"1.1916", "JPY"=>"131.25", "BGN"=>"1.9558", "CZK"=>"26.045", "DKK"=>"7.4391", "GBP"=>"0.92246", "HUF"=>"305.68", "PLN"=>"4.2598", "RON"=>"4.5915", "SEK"=>"9.5095", "CHF"=>"1.1422", "NOK"=>"9.2845", "HRK"=>"7.4135", "RUB"=>"69.8224", "TRY"=>"4.1235", "AUD"=>"1.5016", "BRL"=>"3.7768", "CAD"=>"1.4961", "CNY"=>"7.8559", "HKD"=>"9.3259", "IDR"=>"15903.69", "ILS"=>"4.2705", "INR"=>"76.2925", "KRW"=>"1338.36", "MXN"=>"21.2869", "MYR"=>"5.0887", "NZD"=>"1.6477", "PHP"=>"61.04", "SGD"=>"1.6167", "THB"=>"39.597", "ZAR"=>"15.5563" } }
      end

      def currency_list
        ['ABC', 'DEF']
      end
    end
  end
end
