require 'nokogiri'
require 'open-uri'

module ExchangeRateJt
  module RatesSource
    class CouldNotFetchDataError < StandardError; end
    class ParseError < StandardError; end

    class ECB
      REPOSITORY_URL = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'.freeze
      CURRENCY_LIST = %w(AUD BGN BRL CAD CHF CNY CZK DKK GBP HKD HRK HUF IDR ILS INR JPY KRW MXN MYR NOK NZD PHP PLN RON RUB SEK SGD THB TRY USD ZAR).freeze

      def fetch_rates
        doc = fetch_source
        parse(doc)
      end

      def currency_list
        CURRENCY_LIST
      end

      private

      def fetch_source
        Nokogiri::XML(open(REPOSITORY_URL, read_timeout: 5000))
      rescue Timeout::Error
        handle_fetch_error('the request timed out')
      rescue OpenURI::HTTPError => error
        handle_fetch_error(error)
      end

      def parse(doc)
        daily_updates = doc.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube')
        daily_updates.each_with_object({}) do |daily_update, results_hash|
          strtime = daily_update.attribute('time').value
          date = format_date(strtime)
          results_hash[date] = {}
          daily_update.children.each do |rate|
            curr = rate.attribute('currency').value
            results_hash[date][curr] = rate.attribute('rate').value
          end
        end
      rescue
        raise ParseError, 'There was an error parsing the document'
      end

      def format_date(time_as_string)
        DateTime.parse(time_as_string).strftime('%b_%d_%Y').downcase.to_sym
      end

      def handle_fetch_error(error)
        response = error.io
        code = response.status[0]
        raise CouldNotFetchDataError, "There was an problem fetching the data from the source - #{code}"
      end
    end
  end
end
