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

      expect(accounts.first.id).to eq "12345"
      expect(accounts.first.number).to eq "67890"
      expect(accounts.first.name).to eq "Test User"
      expect(accounts.first.reference_name).to eq "My Private Investec Bank Account"
      expect(accounts.first.product_name).to eq "Private Bank Account"

      expect(accounts.last.id).to eq "223344"
      expect(accounts.last.number).to eq "556677"
      expect(accounts.last.name).to eq "Test User"
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

  describe "#create_transfer" do
    let(:amount)                  { 500 }
    let(:destination_account_id)  { 'destination_account_id' }
    let(:source_account_id)       { 'source_account_id' }
    let(:reference)               { 'A sample reference' }
    let(:destination_reference)   { 'A different reference' }
    let(:date_string)             { DateTime.current.strftime('%m/%d/%Y') }

    let(:sample_transfer) do
      InvestecOpenApi::Models::Transfer.new(
        amount:                 amount,
        destination_account_id: destination_account_id,
        source_account_id:      source_account_id,
        reference:              reference,
        destination_reference:  destination_reference
      )
    end

    let(:response) do
      {
        body: {
          "data": {
            "transferResponse": {
              "TransferResponses": [
                {
                  "PaymentReferenceNumber": "ABC123456",
                  "PaymentDate": date_string,
                  "Status": "- Payment/Transfer effective date #{date_string}",
                  "BeneficiaryName": "Test",
                  "BeneficiaryAccountId": "12345678",
                  "AuthorisationRequired": false
                }
              ],
              "ErrorMessage": nil
            }
          }
        }.to_json
      }
    end

    before do
      stub_request(:post, "#{InvestecOpenApi.api_url}za/pb/v1/accounts/transfermultiple").with(
        body: sample_transfer.request_template.to_json,
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer 123",
          "User-Agent" => "Faraday v1.0.1"
        }
      )
      .to_return(
        response
      )

      sample_transfer.destination_reference = reference
      stub_request(:post, "#{InvestecOpenApi.api_url}za/pb/v1/accounts/transfermultiple").with(
        body: sample_transfer.request_template.to_json,
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer 123",
          "User-Agent" => "Faraday v1.0.1"
        }
      )
      .to_return(
        response
      )

      client.authenticate!
    end

    it "creates the transfer and populates the InvestecOpenApi::Models::Transaction instance" do
      transfer = client.create_transfer(
        amount: amount,
        source_account_id: source_account_id,
        destination_account_id: destination_account_id,
        source_reference: reference,
        destination_reference: destination_reference
      )

      expect(transfer).to be_an_instance_of(InvestecOpenApi::Models::Transfer)
      expect(transfer.status).to eq("- Payment/Transfer effective date #{date_string}")
    end

    it "defaults the destination reference to the source reference if not provided" do
      transfer = client.create_transfer(
        amount: amount,
        source_account_id: source_account_id,
        destination_account_id: destination_account_id,
        source_reference: reference
      )

      expect(transfer.destination_reference).to eq(reference)
    end

    context 'when an error is triggered' do
      let(:response) do
        {
          body: {
            "data": {
              "transferResponse": {
                "TransferResponses": [
                  {}
                ],
                "ErrorMessage": "Insufficient Funds"
              }
            }
          }.to_json
        }
      end

      it "populates the error field" do
        transfer = client.create_transfer(
          amount: amount,
          source_account_id: source_account_id,
          destination_account_id: destination_account_id,
          source_reference: reference,
          destination_reference: destination_reference
        )

        expect(transfer.error_message).to eq("Insufficient Funds")
      end


    end
  end

  describe "#balance" do
    let(:response) do
      {
        body: {
          "data" => {
            "accountId" => "123456",
            "currentBalance" => 90.0,
            "availableBalance" => 100.0,
            "currency" => "ZAR"
          }
        }.to_json
      }
    end

    before do
      stub_request(:get, "#{InvestecOpenApi.api_url}za/pb/v1/accounts/123456/balance").with(
        headers: {
          "Accept" => "application/json",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer 123",
          "User-Agent" => "Faraday v1.0.1"
        }
      )
      .to_return(
        response
      )

      client.authenticate!
    end

    it 'retrieves the balances' do
      expect(client.balance('123456')).to eq(Money.new(100, 'ZAR'))
      expect(client.balance('123456', balance_type: :current)).to eq(Money.new(90, 'ZAR'))
    end

  end
end
