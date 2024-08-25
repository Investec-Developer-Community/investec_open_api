# frozen_string_literal: true

require 'rspec'
require "investec_open_api/models/balance"

RSpec.describe InvestecOpenApi::Models::Balance do
  describe ".from_api" do
    context "with valid attributes" do
      it "should return a new 'Balance' instance" do
        params = {
          "accountId" => Faker::Number.number(digits: 10),
          "currentBalance" => Faker::Number.number(digits: 8),
          "availableBalance" => Faker::Number.number(digits: 8),
          "budgetBalance" => Faker::Number.number(digits: 8),
          "straightBalance" => Faker::Number.number(digits: 8),
          "cashBalance" => Faker::Number.number(digits: 8),
          "currency" => "ZAR"
        }

        balance = InvestecOpenApi::Models::Balance.from_api(params)

        expect(balance.id).to eq params["accountId"]
        expect(balance.current_balance).to eq Money.from_cents(params["currentBalance"], params["currency"])
        expect(balance.available_balance).to eq Money.from_cents(params["availableBalance"], params["currency"])
        expect(balance.budget_balance).to eq Money.from_cents(params["budgetBalance"], params["currency"])
        expect(balance.straight_balance).to eq Money.from_cents(params["straightBalance"], params["currency"])
        expect(balance.cash_balance).to eq Money.from_cents(params["cashBalance"], params["currency"])
        expect(balance.currency).to eq "ZAR"
      end
    end
  end
end
