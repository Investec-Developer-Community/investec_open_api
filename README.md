# InvestecOpenApi Client

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
    config.api_username = "https://openapi.investec.com/"
    config.api_password = "<Open API username>"
    config.api_url = "<Open API password>"
end
```

You will need to register for Open API access. Follow the steps in [Enrolment in the documentation](https://developer.investec.com/programmable-banking/#enrolment).


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
