## 🌟 Community-Powered Repository 🌟

This repository is crafted with ❤️ by our talented community members. It's a space for everyone to use, contribute to, and share. While it aligns with the spirit of our community, please note that this repo is not directly endorsed or supported by Investec. Always exercise caution and discretion when using or contributing to community-driven projects.

# InvestecOpenApi Client

[![Gem Version](https://badge.fury.io/rb/investec_open_api.svg)](https://badge.fury.io/rb/investec_open_api)

A simple client wrapper for the [Investec Open API](https://developer.investec.com/za/api-products).

*Features:*

- Authorize access via OAuth
- Retrieve accounts
- Retrieve transactions per account
- Retrieve balances per account
- Transfer between accounts

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

## Configuration

To configure the client, create a new file in the root of your directory called `.env` and place the following:

```dotenv
API_KEY='YOUR API KEY'
CLIENT_ID='YOUR CLIENT ID'
CLIENT_SECRET='YOUR CLIENT SECRET'
```

> **Note:** you will need to register to get the above credentials.
> Follow the steps in [Enrolment in the documentation](https://developer.investec.com/programmable-banking/#enrolment).
> You can also test in sandbox mode (see [Running in Sandbox Mode](#running-in-sandbox-mode)).

Once you have set this up, configure the client using:

```ruby
InvestecOpenApi.configuration do |config|
    config.api_key       = ENV['API_KEY']
    config.client_id     = ENV['CLIENT_ID']
    config.client_secret = ENV['CLIENT_SECRET']
    config.base_url      = ENV['BASE_URL'] # optional
end
```

For Rails apps, create a new initializer called `investec_open_api.rb` in `config/initializers`:

## Usage

To use the wrapper, create an instance of `InvestecOpenApi::Client` and then authenticate with your credentials:

```ruby
client = InvestecOpenApi::Client.new
client.authenticate!
```

### Accounts

Calling `accounts` returns all of the associated accounts:

```ruby
accounts = client.accounts
my_account = accounts.first
```

### List transactions for an account

You can list your transactions by passing the account id into the `transactions` method:

```ruby
client.transactions(my_account.id)
```

### Get Balance for an account

Pass the `account_id` into the `balance` method to get the latest account balances:

```ruby
client.balance(my_account.id)
```

### Inter-account transfers

To transfer between accounts, create a `InvestecOpenApi::Models::Transfer` object and pass it into the `transfer_multiple` method:

```ruby
transfer = InvestecOpenApi::Models::Transfer.new(
  beneficiary_account_id,
  1000.00, # amount as a Float
  "My reference - of the account transferring from",
  "Their reference - of the account transferring to"
)
client.transfer_multiple(
  my_account.id,
  [ transfer ],
  profile_id # optional
)
```

## Running in Sandbox mode

To run in sandbox mode, use the following configuration:

```ruby
InvestecOpenApi.configuration do |config|
  config.api_key = "eUF4elFSRlg5N3ZPY3lRQXdsdUVVNkg2ZVB4TUE1ZVk6YVc1MlpYTjBaV010ZW1FdGNHSXRZV05qYjNWdWRITXRjMkZ1WkdKdmVBPT0="
  config.client_id = "yAxzQRFX97vOcyQAwluEU6H6ePxMA5eY"
  config.client_secret = "4dY0PjEYqoBrZ99r"
  config.base_url = "https://openapisandbox.investec.com/"
end
```

You can now test the API without affecting your actual account.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
