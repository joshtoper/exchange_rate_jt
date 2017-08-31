require 'nokogiri'
require 'open-uri'

module ExchangeRateJt
  module RatesSource
    class CouldNotFetchDataError < StandardError; end
    class ParseError < StandardError; end

    class ECB
      REPOSITORY_URL = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'.freeze

      def fetch_rates
        doc = fetch_source
        parse(doc)
      end

      private

      def fetch_source
        Nokogiri::XML(open(REPOSITORY_URL))
      rescue
        raise CouldNotFetchDataError,
              'There was an error fetching the data from the source'
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
        raise ParseError,
              'There was an error parsing the document'
      end

      def format_date(time_as_string)
        DateTime.parse(time_as_string).strftime('%b_%d_%Y').downcase.to_sym
      end
    end
  end
end
