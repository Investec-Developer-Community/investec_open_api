RSpec.describe InvestecOpenApi::Models::Account do
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
  end

  describe "#from_api" do
    context "with valid attributes" do
      it "returns a new instance of InvestecOpenApi::Models::Account with attributes" do
        model_instance = InvestecOpenApi::Models::Account.from_api({
          "accountId" => "12345",
          "accountNumber" => "67890",
          "accountName" => "Test User",
          "referenceName" => "Savings Account",
          "productName" => "Private Bank Account"
        })

        expect(model_instance.id).to eq "12345"
        expect(model_instance.number).to eq "67890"
        expect(model_instance.name).to eq "Test User"
        expect(model_instance.reference_name).to eq "Savings Account"
        expect(model_instance.product_name).to eq "Private Bank Account"
      end
    end

    context "with valid and invalid attributes" do
      it "returns a new instance of InvestecOpenApi::Models::Account with only valid attributes" do
        model_instance = InvestecOpenApi::Models::Account.from_api({
          "accountId" => "12345",
          "bankAccountNumber" => "67890"
        })

        expect(model_instance.id).to eq "12345"
        expect(model_instance.number).to eq nil
        expect(model_instance.name).to eq nil
        expect(model_instance.reference_name).to eq nil
        expect(model_instance.product_name).to eq nil

        expect { model_instance.bank_account_number }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#transactions" do
    let(:account) do
      InvestecOpenApi::Models::Account.from_api({
          "accountId" => "12345",
          "accountNumber" => "67890",
          "accountName" => "Test User",
          "referenceName" => "Savings Account",
          "productName" => "Private Bank Account"
        })
    end

    it "responds to #transactions" do
      expect(account.respond_to?(:transactions)).to be_truthy
    end

    context "when the api returns transactions" do
      it "returns the account's transactions" do
        expected_transactions = account.transactions
        expect(expected_transactions).to be_an_instance_of(Array)
        expect(expected_transactions.first).to be_an_instance_of(InvestecOpenApi::Models::Transaction)
      end
    end
  end

  describe ".find" do
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
    end

    it "finds an account by its id" do
      expect(described_class.find("12345")).to be_an_instance_of(described_class)
    end

    context "when an account does not exist" do
      it "raises a NotFoundError if no account is found" do
        expect{described_class.find("1")}.to raise_error(InvestecOpenApi::NotFoundError)
      end
    end
  end

  describe ".all" do
    it "queries all accessible accounts" do
      expect_any_instance_of(InvestecOpenApi::Client).to receive(:accounts)
      described_class.all
    end
  end
end
