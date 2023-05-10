require "faraday"
require "faraday_middleware"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"

class InvestecOpenApi::Client
  INVESTEC_API_URL="https://openapi.investec.com/"

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

  def transfer(account_id, to_account_id, amount, my_reference, their_reference)
    response = connection.post(
      "za/pb/v1/accounts/#{account_id}/transfermultiple",
       {
          transferList: [
          {
            beneficiaryAccountId: to_account_id,
            amount: amount,
            myReference: my_reference,
            theirReference: their_reference
          }
        ]
      }
    )

    response.body["data"]["TransferResponses"].map do |transfer_raw|
      InvestecOpenApi::Models::Transfer.from_api(transfer_raw)
    end
  end

  private

  def get_oauth_token
    auth_token = Base64.strict_encode64("#{InvestecOpenApi.client_id}:#{InvestecOpenApi.client_secret}")

    response = Faraday.post(
      "#{INVESTEC_API_URL}identity/v2/oauth2/token",
      { grant_type: "client_credentials" },
      {
        'x-api-key' => InvestecOpenApi.api_key,
        'Authorization' => "Basic #{auth_token}"
      }
    )

    JSON.parse(response.body)
  end

  def connection
    @_connection ||= Faraday.new(url: INVESTEC_API_URL) do |builder|
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
