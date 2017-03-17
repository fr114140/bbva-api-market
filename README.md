# Bbva::Api::Market (WIP)

BBVA API Market Ruby integration. This gem needs OAuth2 authentication wrapped in this gem: https://github.com/the-cocktail/omniauth-bbva
And both of them are used in: https://github.com/the-cocktail/demo-bbvaapimarket

BBVA API documentation: https://www.bbvaapimarket.com/

This gem do not have all the services of the BBVA API Market, it's work in progress. Feel free to upgrade it with new features. It be more than welcome :)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bbva-api-market', git: 'git://github.com/the-cocktail/bbva-api-market'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bbva-api-market

## Usage

### CLIENT

This gem contains also a client with some basic services of BBVA API MARKET like:
- Identity
- Accounts (https://www.bbvaapimarket.com/products/accounts)
- Cards (https://www.bbvaapimarket.com/products/cards)
- Payments (https://www.bbvaapimarket.com/products/payments)

An also the ```refresh_token```method to used once the credentials have expired.

### Using Client in Rails

- Include the module
    ```ruby
    include Bbva::Api::Market
    ```
    
- Instanciate
    ```ruby
      @client = Bbva::Client.new do |config|
        config.client_id      = "YOUR_CLIENT_ID"
        config.secret         = "YOUR_SECRET"
        config.token          = "YOUR_ACCESS_TOKEN"
        config.refresh_token  = "YOUR_REFRESH_TOKEN"
        config.code           = 'YOUR_CODE'
      end
      #or
      @client ||= Bbva::Api::Market::Client.new(hash_with_credentials)
    ```
    
- Finally get some data
```ruby
    #Personal information
    @me        = @client.identity
    #Get all acounts
    @accounts  = @client.accounts
    #Get a specific account
    @account   = @client.accounts(account_id)
    #Get all cards
    @cards     = @client.cards
    #Get a specific card
    @card      = @client.cards(card_id)
```

### Paystats
https://www.bbvaapimarket.com/products/paystats

This gem contains also a Paystats with some basic services of BBVA API MARKET like:
- Zipcode basic stats

### Using Paystats in Rails

- Create a new instance of Paystats class
```ruby
    @paystats ||= Bbva::Api::Market::Paystats.new({client_id: CLIENT_ID , secret: CLIENT_SECRET})
```

- Get some data
```ruby
    @basic_stats  = @paystats.zipcode_basic_stats(28020, "201509", 10, "es_home", "month", "201512", "201509")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bbva-api-market. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

