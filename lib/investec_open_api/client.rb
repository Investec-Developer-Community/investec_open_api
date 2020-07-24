require "faraday"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"

class InvestecOpenApi::Client
  API_URL = InvestecOpenApi.api_url

  def authenticate!
    auth = get_oauth_token(
      username: InvestecOpenApi.api_username,
      password: InvestecOpenApi.api_password
    )
    @token = auth['access_token']
  end

  def accounts
    response = connection.get("za/pb/v1/accounts")
    response.body["data"]["accounts"].map do |account_raw|
      InvestecOpenApi::Models::Account.from_api(account_raw)
    end
  end

  def transactions(account_id:)
    response = connection.get("za/pb/v1/accounts/#{account_id}/transactions")
    response.body["data"]["transactions"].map do |transaction_raw|
      InvestecOpenApi::Models::Transaction.from_api(transaction_raw)
    end
  end

  def get_oauth_token(username:, password:)
    auth_connection = Faraday.new(url: API_URL) do |builder|
      builder.basic_auth(username, password)
      builder.response :raise_error
      builder.response :json
      builder.adapter Faraday.default_adapter
    end

    response = auth_connection.post("identity/v2/oauth2/token", {
      grant_type: "client_credentials",
      scope: "accounts"
    }.to_query)

    response.body
  end

  def connection
    @_connection ||= Faraday.new(url: API_URL) do |builder|
      if @token
        builder.headers['Authorization'] = "Bearer #{@token}"
      end

      builder.request :json

      builder.response :raise_error
      builder.response :json

      builder.adapter Faraday.default_adapter
    end
  end
end
