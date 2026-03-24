# frozen_string_literal: true

require "faraday"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"
require "investec_open_api/models/balance"
require "investec_open_api/models/transfer"
require "investec_open_api/camel_case_refinement"
require "base64"

class InvestecOpenApi::Client
  using InvestecOpenApi::CamelCaseRefinement

  def authenticate!
    @token = get_oauth_token["access_token"]
  rescue StandardError => e
    raise InvestecOpenApi::AuthenticationError, "Failed to authenticate: #{e.message}"
  end

  # Get all accounts for the authenticated user
  # @return [Array<InvestecOpenApi::Models::Account>]
  # @raise [InvestecOpenApi::APIError] if the request fails
  def accounts
    response = connection.get("za/pb/v1/accounts")
    response.body["data"]["accounts"].map do |account_raw|
      InvestecOpenApi::Models::Account.from_api(account_raw)
    end
  rescue StandardError => e
    raise InvestecOpenApi::APIError, "Failed to fetch accounts: #{e.message}"
  end

  # Get cleared transactions for an account
  # @param [String] account_id The id of the account to get transactions for
  # @param [Hash] options Optional query parameters
  # @option options [String] :fromDate Start date from which to get transactions
  # @option options [String] :toDate End date for transactions
  # @option options [String] :transactionType Type of transaction to filter by (e.g., CardPurchases, Deposits)
  # @return [Array<InvestecOpenApi::Models::Transaction>]
  # @raise [InvestecOpenApi::ValidationError] if account_id is blank
  # @raise [InvestecOpenApi::APIError] if the request fails
  def transactions(account_id, options = {})
    raise InvestecOpenApi::ValidationError, "account_id cannot be blank" if account_id.to_s.strip.empty?

    endpoint_url = "za/pb/v1/accounts/#{account_id}/transactions"
    perform_transaction_request(endpoint_url, options)
  rescue InvestecOpenApi::ValidationError
    raise
  rescue StandardError => e
    raise InvestecOpenApi::APIError, "Failed to fetch transactions: #{e.message}"
  end

  # Get pending transactions for an account
  # @param [String] account_id The id of the account to get pending transactions for
  # @param [Hash] options Optional query parameters
  # @option options [String] :fromDate Start date from which to get pending transactions
  # @option options [String] :toDate End date for pending transactions
  # @return [Array<InvestecOpenApi::Models::Transaction>]
  # @raise [InvestecOpenApi::ValidationError] if account_id is blank
  # @raise [InvestecOpenApi::APIError] if the request fails
  def pending_transactions(account_id, options = {})
    raise InvestecOpenApi::ValidationError, "account_id cannot be blank" if account_id.to_s.strip.empty?

    endpoint_url = "za/pb/v1/accounts/#{account_id}/pending-transactions"
    perform_transaction_request(endpoint_url, options)
  rescue InvestecOpenApi::ValidationError
    raise
  rescue StandardError => e
    raise InvestecOpenApi::APIError, "Failed to fetch pending transactions: #{e.message}"
  end

  # Get balance for an account
  # @param [String] account_id The id of the account to get balance for
  # @return [InvestecOpenApi::Models::Balance]
  # @raise [InvestecOpenApi::ValidationError] if account_id is blank
  # @raise [InvestecOpenApi::NotFoundError] if account not found or balance data unavailable
  # @raise [InvestecOpenApi::APIError] if the request fails
  def balance(account_id)
    raise InvestecOpenApi::ValidationError, "account_id cannot be blank" if account_id.to_s.strip.empty?

    endpoint_url = "za/pb/v1/accounts/#{account_id}/balance"
    response = connection.get(endpoint_url)
    raise InvestecOpenApi::NotFoundError, "Balance data not found for account #{account_id}" if response.body["data"].nil?

    InvestecOpenApi::Models::Balance.from_api(response.body["data"])
  rescue InvestecOpenApi::ValidationError, InvestecOpenApi::NotFoundError
    raise
  rescue StandardError => e
    raise InvestecOpenApi::APIError, "Failed to fetch balance: #{e.message}"
  end

  # Transfer funds between accounts
  # @param [String] account_id The id of the account to transfer from
  # @param [Array<InvestecOpenApi::Models::Transfer>] transfers List of transfers to perform
  # @param [String, nil] profile_id Optional profile ID for the transfer
  # @return [Hash] The response body from the API
  # @raise [InvestecOpenApi::ValidationError] if parameters are invalid
  # @raise [InvestecOpenApi::APIError] if the request fails
  def transfer_multiple(
    account_id,
    transfers,
    profile_id = nil
  )
    raise InvestecOpenApi::ValidationError, "account_id cannot be blank" if account_id.to_s.strip.empty?
    raise InvestecOpenApi::ValidationError, "transfers cannot be empty" if transfers.nil? || transfers.empty?

    endpoint_url = "za/pb/v1/accounts/#{account_id}/transfermultiple"
    data = {
      transferList: transfers.map(&:to_h),
    }
    data[:profileId] = profile_id if profile_id
    response = connection.post(
      endpoint_url,
      JSON.generate(data)
    )
    response.body
  rescue InvestecOpenApi::ValidationError
    raise
  rescue StandardError => e
    raise InvestecOpenApi::APIError, "Failed to process transfers: #{e.message}"
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
    # NOTE: This connection is cached in an instance variable. If you use this client
    # in a multi-threaded environment, ensure each thread has its own client instance.
    # The connection itself is thread-safe (Faraday uses thread-safe adapters),
    # but the caching mechanism is not.
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

  def perform_transaction_request(endpoint_url, options)
    unless options.empty?
      query_string = URI.encode_www_form(options.camelize)
      endpoint_url += "?#{query_string}"
    end

    response = connection.get(endpoint_url)
    response.body["data"]["transactions"].map do |transaction_raw|
      InvestecOpenApi::Models::Transaction.from_api(transaction_raw)
    end
  end
end
