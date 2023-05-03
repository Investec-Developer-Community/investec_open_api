# InvestecOpenApi Client

[![Gem Version](https://badge.fury.io/rb/investec_open_api.svg)](https://badge.fury.io/rb/investec_open_api)
[![Build Status](https://travis-ci.com/Offerzen/investec_open_api.svg?branch=master)](https://travis-ci.com/Offerzen/investec_open_api)

A simple client wrapper for the [Investec Open API](https://developer.investec.com/programmable-banking/#open-api).

*Features:*

- Authorize access via OAuth
- Retrieve accounts
- Retrieve transactions per account

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'investec_open_api'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install investec_open_api
```

Create a new initializer called `investec_open_api.rb` in `config/initializers`:

```ruby
InvestecOpenApi.configuration do |config|
    config.api_key      = ENV['API_KEY']
    config.client_id    = ENV['CLIENT_ID']
    config.client_secret = ENV['CLIENT_SECRET']
end
```

Create a new file in the root of your directory called `.env` and place the following:

```
API_KEY='YOUR API KEY'
CLIENT_ID='YOUR CLIENT ID'
CLIENT_SECRET='YOUR CLIENT SECRET'
```

You will need to register to get the following credentials. Follow the steps in [Enrolment in the documentation](https://developer.investec.com/programmable-banking/#enrolment).


## Usage

To use the wrapper, create an instance of `InvestecOpenApi::Client` and then authenticate with your credentials:

```ruby
client = InvestecOpenApi::Client.new
client.authenticate!
```

Once authenticated you can retrieve your accounts:

```ruby
accounts = client.accounts
my_account = accounts.first
```

Use the ID of one of your accounts to retrieve transactions:

```ruby
client.transactions(my_account.id)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
