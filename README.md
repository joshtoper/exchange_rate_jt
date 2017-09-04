# ExchangeRateJt

This is a simple gem whose primary purpose is to retrieve up-to-date exchange rate data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exchange_rate_jt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exchange_rate_jt

## Usage

### Configuration
Before using the gem, you will need to specify some configuration values, an example of which is shown below:

```
ExchangeRateJt.configure do |config|
  config.source = :ecb
  config.data_store_type = :pstore
  config.data_store = PStore.new('store.my_pstore')
  config.default_currency = :EUR
end
```

At time of writing, the only data source is the European Central Bank, and the only storage type is Ruby's PStore. However, the gem is structured to make extension very simple.

### Methods

The gem currently performs three operations:

#### Fetching latest rates

```
ExchangeRateJt.update_exchange_rates
```

This will fetch the latest rates from the specified source, and persist them to the specified storage.

#### Calculating an exchange rate for a given day

```
date = Date.today
ExchangeRateJt.at(date, 'GBP', 'USD')

==> { status: :success, rate: 1.2345 }
```

This will return the exchange rate between two currencies for a given day, providing the data is available.

#### Fetching a list of available currencies

```
ExchangeRateJt.currency_list
```

This returns an array of all available currencies for the current rates source.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JoshToper/exchange_rate_jt.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
