require "faraday"
require "faraday_middleware"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"

class InvestecOpenApi::Client
  def authenticate!
    @token = get_oauth_token["access_token"]
  end

  def accounts
    response = connection.get("za/pb/v1/accounts")
    response.body["data"]["accounts"].map do |account_raw|
      InvestecOpenApi::Models::Account.from_api(account_raw)
    end
  end

  def transactions(account_id)
    response = connection.get("za/pb/v1/accounts/#{account_id}/transactions")
    response.body["data"]["transactions"].map do |transaction_raw|
      InvestecOpenApi::Models::Transaction.from_api(transaction_raw)
    end
  end

  private

  def get_oauth_token
    auth_connection = Faraday.new(url: InvestecOpenApi.api_url) do |builder|
      builder.headers["Accept"] = "application/json"
      builder.request(:basic_auth, InvestecOpenApi.api_username, InvestecOpenApi.api_password)
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
    @_connection ||= Faraday.new(url: InvestecOpenApi.api_url) do |builder|
      if @token
        builder.headers["Authorization"] = "Bearer #{@token}"
      end

      builder.headers["Accept"] = "application/json"
      builder.request :json

      builder.response :raise_error
      builder.response :json

      builder.adapter Faraday.default_adapter
    end
  end
end
