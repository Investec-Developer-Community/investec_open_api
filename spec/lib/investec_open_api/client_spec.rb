require "spec_helper"
require "investec_open_api/client"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"

RSpec.describe InvestecOpenApi::Client do
  let(:client) { InvestecOpenApi::Client.new }

  before do
    InvestecOpenApi.api_url = "https://openapistg.investec.com/"
    InvestecOpenApi.api_username = "Test"
    InvestecOpenApi.api_password = "Secret"

    stub_request(:post, "#{InvestecOpenApi.api_url}identity/v2/oauth2/token")
      .with(
        body: "grant_type=client_credentials&scope=accounts",
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => Faraday::Connection.new.basic_auth("Test", "Secret"),
          "User-Agent" => "Faraday v1.0.1"
        }
      )
      .to_return(body: { "access_token" => "123","token_type" => "Bearer", "expires_in" => 1799, "scope" =>"accounts" }.to_json)
  end

  describe "#accounts" do
    before do
      stub_request(:get, "#{InvestecOpenApi.api_url}za/pb/v1/accounts")
        .with(
          body: "",
          headers: {
            "Accept" => "application/json",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Authorization" => "Bearer 123",
            "User-Agent" => "Faraday v1.0.1"
          }
        )
        .to_return(
          body: {
            data: {
              accounts: [
                {
                  "accountId" => "12345",
                  "accountNumber" => "67890",
                  "accountName" => "Test User",
                  "referenceName" => "My Private Investec Bank Account",
                  "productName" => "Private Bank Account"
                },
                {
                  "accountId" => "223344",
                  "accountNumber" => "556677",
                  "accountName" => "Test User",
                  "referenceName" => "My Private Investec Savings Account",
                  "productName" => "Private Savings Account"
                }
              ]
            }
          }.to_json
        )

      client.authenticate!
    end

    it "returns all accounts for the authorized user as InvestecOpenApi::Models::Account instances" do
      accounts = client.accounts

      expect(accounts.first).to be_an_instance_of(InvestecOpenApi::Models::Account)

      expect(accounts.first.account_id).to eq "12345"
      expect(accounts.first.account_number).to eq "67890"
      expect(accounts.first.account_name).to eq "Test User"
      expect(accounts.first.reference_name).to eq "My Private Investec Bank Account"
      expect(accounts.first.product_name).to eq "Private Bank Account"

      expect(accounts.last.account_id).to eq "223344"
      expect(accounts.last.account_number).to eq "556677"
      expect(accounts.last.account_name).to eq "Test User"
      expect(accounts.last.reference_name).to eq "My Private Investec Savings Account"
      expect(accounts.last.product_name).to eq "Private Savings Account"
    end
  end
 
  describe "#transactions" do
    before do
      stub_request(:get, "#{InvestecOpenApi.api_url}za/pb/v1/accounts/12345/transactions")
        .with(
          body: "",
          headers: {
            "Accept" => "application/json",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Authorization" => "Bearer 123",
            "User-Agent" => "Faraday v1.0.1"
          }
        )
        .to_return(
          body: {
            data: {
              transactions: [
                {
                  "accountId": "12345",
                  "type": "DEBIT",
                  "status": "POSTED",
                  "description": "MONTHLY SERVICE CHARGE",
                  "cardNumber": "",
                  "postingDate": "2020-06-11",
                  "valueDate": "2020-06-10",
                  "actionDate": "2020-06-18",
                  "amount": 535
                },
                {
                  "accountId": "12345",
                  "type": "CREDIT",
                  "status": "POSTED",
                  "description": "CREDIT INTEREST",
                  "cardNumber": "",
                  "postingDate": "2020-06-11",
                  "valueDate": "2020-06-10",
                  "actionDate": "2020-06-18",
                  "amount": 31.09
                }
              ]
            }
          }.to_json
        )

      client.authenticate!
    end

    it "returns all transactions for the specified account id as InvestecOpenApi::Models::Transaction instances" do
      transactions = client.transactions("12345")

      expect(transactions.first).to be_an_instance_of(InvestecOpenApi::Models::Transaction)
    end
  end
end
