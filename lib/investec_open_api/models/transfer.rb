# frozen_string_literal: true

module InvestecOpenApi::Models
  class Transfer
    attr_reader :beneficiary_account_id, :amount, :my_reference, :their_reference

    # @param [String] beneficiary_account_id The ID of the beneficiary account
    # @param [Float] amount The amount to transfer
    # @param [String] my_reference Reference visible to the sender
    # @param [String] their_reference Reference visible to the recipient
    # @raise [InvestecOpenApi::ValidationError] if required parameters are blank
    def initialize(
      beneficiary_account_id,
      amount,
      my_reference,
      their_reference
    )
      raise InvestecOpenApi::ValidationError, "beneficiary_account_id cannot be blank" if beneficiary_account_id.to_s.strip.empty?
      raise InvestecOpenApi::ValidationError, "amount cannot be nil or zero" if amount.nil? || amount.to_f.zero?
      raise InvestecOpenApi::ValidationError, "my_reference cannot be blank" if my_reference.to_s.strip.empty?
      raise InvestecOpenApi::ValidationError, "their_reference cannot be blank" if their_reference.to_s.strip.empty?

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
