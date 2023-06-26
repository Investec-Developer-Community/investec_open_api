require "faraday"
require "faraday_middleware"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"
require "investec_open_api/camel_case_refinement"

class InvestecOpenApi::Client
  using InvestecOpenApi::CamelCaseRefinement
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

  def transactions(account_id, options = {})
    endpoint_url = "za/pb/v1/accounts/#{account_id}/transactions"

    unless options.empty?
      query_string = URI.encode_www_form(options.camelize)
      endpoint_url += "?#{query_string}"
    end
    
    response = connection.get(endpoint_url)
    response.body["data"]["transactions"].map do |transaction_raw|
      InvestecOpenApi::Models::Transaction.from_api(transaction_raw)
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

  def camelize(snake_string)
    words = snake_string.split('_')
    words.drop(1).collect(&:capitalize).unshift(words.first).join
  end
end
