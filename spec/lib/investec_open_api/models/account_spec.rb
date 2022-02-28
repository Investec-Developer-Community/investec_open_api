require "spec_helper"
require "investec_open_api/models/account"

RSpec.describe InvestecOpenApi::Models::Account do
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

  describe "#balance" do
    let(:response) do
      {
        "data" => {
          "accountId" => "123456",
          "currentBalance" => 90.0,
          "availableBalance" => 100.0,
          "currency" => "ZAR"
        }
      }
    end

    before do
      stub_request(:post, "#{InvestecOpenApi.api_url}za/pb/v1/accounts/123456/balance").with(
        body: '',
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
    end


  end
end
