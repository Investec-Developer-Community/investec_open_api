# frozen_string_literal: true

require "spec_helper"
require "investec_open_api/models/transfer"

RSpec.describe 'Transfer' do
  it "should accept data for creating a transfer" do
    beneficiary_account_id = Faker::Number.number(digits: 10).to_s
    amount = Faker::Number.decimal(l_digits: 2)
    my_reference = Faker::Lorem.words(number: 5).join("")
    their_reference = Faker::Lorem.words(number: 5).join("")
    sut = InvestecOpenApi::Models::Transfer.new(
      beneficiary_account_id,
      amount,
      my_reference,
      their_reference
    )
    expect(sut.beneficiary_account_id).to eq(beneficiary_account_id)
    expect(sut.amount).to eq(amount.to_s)
    expect(sut.my_reference).to eq(my_reference)
    expect(sut.their_reference).to eq(their_reference)
  end

  describe "#to_h" do
    it "should return a hash object" do
      beneficiary_account_id = Faker::Number.number(digits: 10).to_s
      amount = Faker::Number.decimal(l_digits: 2)
      my_reference = Faker::Lorem.words(number: 5).join("")
      their_reference = Faker::Lorem.words(number: 5).join("")
      sut = InvestecOpenApi::Models::Transfer.new(
        beneficiary_account_id,
        amount,
        my_reference,
        their_reference
      )
      expect(sut.to_h).to eq({
                               beneficiaryAccountId: beneficiary_account_id,
                               amount: amount.to_s,
                               myReference: my_reference,
                               theirReference: their_reference
                             })
    end
  end
end
