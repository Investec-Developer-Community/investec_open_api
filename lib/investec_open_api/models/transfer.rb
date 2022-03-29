require "money"

module InvestecOpenApi::Models
  class Transfer < Base
    attribute :source_account_id
    attribute :destination_account_id
    attribute :amount
    attribute :reference
    attribute :destination_reference
    attribute :status
    attribute :payment_reference_number
    attribute :payment_date
    attribute :error_message
    attribute :beneficiary_name
    attribute :beneficiary_account_id

    def assign_from_api(params = {})
      params["TransferResponses"]&.first&.merge!({'ErrorMessage' => params['ErrorMessage']})
      params["TransferResponses"] ||= {'ErrorMessage' => params['ErrorMessage']}

      super(params)
    end

    def request_template
      {
        AccountId: source_account_id,
        TransferList: [
          {
            BeneficiaryAccountId: destination_account_id,
            Amount: amount,
            MyReference: reference,
            TheirReference: destination_reference || reference
          }
        ]
      }
    end

  end
end
