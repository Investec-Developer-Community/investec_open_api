RSpec.describe InvestecOpenApi::Models::Transaction do
  describe "#from_api" do
    context "with valid attributes" do
      it "returns a new instance of InvestecOpenApi::Models::Transaction with attributes" do
        model_instance = InvestecOpenApi::Models::Transaction.from_api({
          "accountId" => "12345",
          "type" => "DEBIT",
          "status" => "POSTED",
          "cardNumber" => "400000xxxxxx0001",
          "amount" => 50000,
          "description" => "COFFEE",
          "transactionDate" => "2020-07-13",
          "postingDate" => "2020-07-14",
          "valueDate" => "2020-07-15",
          "actionDate" => "2020-07-21"
        })

        expect(model_instance.account_id).to eq "12345"
        expect(model_instance.type).to eq "DEBIT"
        expect(model_instance.status).to eq "POSTED"
        expect(model_instance.card_number).to eq "400000xxxxxx0001"
        expect(model_instance.amount.class).to eq Money
        expect(model_instance.amount.to_f).to eq -50000.0
        expect(model_instance.description).to eq "COFFEE"
        expect(model_instance.date).to eq Date.parse("2020-07-13")
        expect(model_instance.posting_date).to eq Date.parse("2020-07-14")
        expect(model_instance.value_date).to eq Date.parse("2020-07-15")
        expect(model_instance.action_date).to eq Date.parse("2020-07-21")
      end
    end

    context "with valid and invalid attributes" do
      it "returns a new instance of InvestecOpenApi::Models::Transaction with only valid attributes" do
        model_instance = InvestecOpenApi::Models::Transaction.from_api({
          "accountId" => "12345",
          "type" => "DEBIT",
          "bankAccountNumber" => "67890"
        })

        expect(model_instance.account_id).to eq "12345"
        expect(model_instance.type).to eq "DEBIT"

        expect { model_instance.bank_account_number }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#id" do
    it "creates a unique ID based on the amount, description and date" do
      model_instance = InvestecOpenApi::Models::Transaction.from_api({
        "accountId" => "12345",
        "type" => "DEBIT",
        "status" => "POSTED",
        "cardNumber" => "400000xxxxxx0001",
        "amount" => 50000,
        "description" => "COFFEE ORDER",
        "transactionDate" => "2020-07-13",
        "postingDate" => "2020-07-14",
        "valueDate" => "2020-07-15",
        "actionDate" => "2020-07-21"
      })

      expect(model_instance.id).to eq "-50000-COFFEE ORDER-2020-07-13"
    end
  end

  describe "#account" do
    let(:transaction) do
      InvestecOpenApi::Models::Transaction.from_api({
        "accountId" => "12345",
        "type" => "DEBIT",
        "status" => "POSTED",
        "cardNumber" => "400000xxxxxx0001",
        "amount" => 50000,
        "description" => "COFFEE ORDER",
        "transactionDate" => "2020-07-13",
        "postingDate" => "2020-07-14",
        "valueDate" => "2020-07-15",
        "actionDate" => "2020-07-21"
      })
    end

    it "responds to #account" do
      expect(transaction.respond_to?(:account)).to be_truthy
    end
  end

  describe ".where" do
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

    let(:account) do
      InvestecOpenApi::Models::Account.from_api({
          "accountId" => "12345",
          "accountNumber" => "67890",
          "accountName" => "Test User",
          "referenceName" => "Savings Account",
          "productName" => "Private Bank Account"
        })
    end

    it "calls the api for all transactions that match an account" do
      expect_any_instance_of(InvestecOpenApi::Client).to receive(:transactions).with(account.id)
      described_class.where(account_id: account.id)
    end

    context "when the api request is valid" do
      it "returns all transactions that match an account" do
        account_transactions = described_class.where(account_id: account.id)
        expect(account_transactions).to be_an_instance_of(Array)
        expect(account_transactions.first).to be_an_instance_of(described_class)
        expect(account_transactions.map{ |t| t.account_id }.uniq).to eql([account.id])
      end
    end

    context "when an account_id is not specified" do
      it "raises an error" do
        expect{ described_class.where() }.to raise_error(InvestecOpenApi::NotFoundError)
      end
    end
  end
end
