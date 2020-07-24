require "money"

module InvestecOpenApi::Models
  class Transaction < Base
    attribute :account_id
    attribute :type
    attribute :status
    attribute :card_number
    attribute :amount
    attribute :description
    attribute :posting_date, type: Date
    attribute :value_date, type: Date
    attribute :action_date, type: Date

    # At this point, there is no unique identifier being returned from Investec's API.
    # This method serves to create a stable unique identifier based on the transaction details.
    def id
      [
        amount.to_i,
        description,
        posting_date.to_s
      ].map(&:to_s).join('-')
    end

    def self.from_api(params)
      if params['amount'].present?
        adjusted_amount = params['amount'] * 100
        adjusted_amount = -adjusted_amount if params['type'] == 'DEBIT'
        params['amount'] = Money.new(adjusted_amount, "ZAR")
      end

      super
    end
  end
end
