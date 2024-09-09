# frozen_string_literal: true

module InvestecOpenApi::Models
  class Transfer
    attr_reader :beneficiary_account_id, :amount, :my_reference, :their_reference

    # @param [String] beneficiary_account_id
    # @param [Float] amount
    # @param [String] my_reference
    # @param [String] their_reference
    def initialize(
      beneficiary_account_id,
      amount,
      my_reference,
      their_reference
    )
      @beneficiary_account_id = beneficiary_account_id
      @amount = amount.to_s
      @my_reference = my_reference
      @their_reference = their_reference
    end

    def to_h
      {
        beneficiaryAccountId: @beneficiary_account_id,
        amount: @amount,
        myReference: @my_reference,
        theirReference: @their_reference
      }
    end
  end
end
