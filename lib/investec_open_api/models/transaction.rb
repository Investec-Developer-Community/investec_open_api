require "money"

module InvestecOpenApi::Models
  class Transaction < Base
    attribute :account_id
    attribute :posted_order
    attribute :type
    attribute :transaction_type
    attribute :status
    attribute :card_number
    attribute :amount
    attribute :description
    attribute :running_balance
    attribute :date, type: Date
    attribute :posting_date, type: Date
    attribute :value_date, type: Date
    attribute :action_date, type: Date

    # At this point, there is no unique identifier being returned from Investec's API.
    # This method serves to create a stable unique identifier based on the transaction details.
    def id
      [
        amount.to_i,
        description,
        date.to_s
      ].map(&:to_s).join('-')
    end

    def self.from_api(params)
      if params['amount'].present?
        adjusted_amount = params['amount'] * 100
        adjusted_amount = -adjusted_amount if params['type'] == 'DEBIT'

        Money.rounding_mode = BigDecimal::ROUND_HALF_UP
        Money.locale_backend = :i18n
        params['amount'] = Money.from_cents(adjusted_amount, "ZAR")
      end

      if params['runningBalance'].present?
        adjusted_amount = params['runningBalance'] * 100

        Money.rounding_mode = BigDecimal::ROUND_HALF_UP
        Money.locale_backend = :i18n
        params['runningBalance'] = Money.from_cents(adjusted_amount, "ZAR")
      end

      if params['transactionDate']
        params['date'] = params['transactionDate']
      end

      super
    end
  end
end
