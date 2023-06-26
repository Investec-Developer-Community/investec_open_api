require "spec_helper"
require "investec_open_api/models/transaction"

RSpec.describe InvestecOpenApi::Models::Transaction do
  describe "#from_api" do
    context "with valid attributes" do
      it "returns a new instance of InvestecOpenApi::Models::Transaction with attributes" do
        model_instance = InvestecOpenApi::Models::Transaction.from_api({
          "accountId" => "12345",
          "type" => "DEBIT",
          "status" => "POSTED",
          "cardNumber" => "400000xxxxxx0001",
          "amount" => 50000.32,
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
        expect(model_instance.amount.to_f).to eq -50000.32
        expect(model_instance.amount.format).to eq "R-50,000.32"
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
end
