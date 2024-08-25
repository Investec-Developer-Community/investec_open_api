require "faraday"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"
require "investec_open_api/camel_case_refinement"
require 'base64'

class InvestecOpenApi::Client
  using InvestecOpenApi::CamelCaseRefinement

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
    auth_token = ::Base64.strict_encode64("#{InvestecOpenApi.config.client_id}:#{InvestecOpenApi.config.client_secret}")

    response = Faraday.post(
      "#{InvestecOpenApi.config.base_url}identity/v2/oauth2/token",
      { grant_type: "client_credentials" },
      {
        'x-api-key' => InvestecOpenApi.config.api_key,
        'Authorization' => "Basic #{auth_token}"
      }
    )

    JSON.parse(response.body)
  end

  def connection
    @_connection ||= Faraday.new(url: InvestecOpenApi.config.base_url) do |builder|
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
