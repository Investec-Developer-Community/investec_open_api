require "money"

module InvestecOpenApi::Models
  class Transaction < Base
    attr_reader :id,
                :account_id,
                :posted_order,
                :type,
                :transaction_type,
                :status,
                :card_number,
                :amount,
                :description,
                :running_balance,
                :date,
                :posting_date,
                :value_date,
                :action_date

    def initialize(params)
      super
      set_id
    end

    # At this point, there is no unique identifier being returned from Investec's API.
    # This method serves to create a stable unique identifier based on the transaction details.
    def set_id
      @id = [
        amount.to_i,
        description,
        date.to_s
      ].map(&:to_s).join('-')
    end

    def self.from_api(params, currency = "ZAR")
      params["currency"] = currency
      should_make_amount_negative = params['type'] == 'DEBIT'
      convert_param_value_to_money(params, "amount", "currency", should_make_amount_negative)
      convert_param_value_to_money(params, "runningBalance")
      rewrite_param_key(params, "transactionDate", "date")
      convert_param_value_to_date(params, "date")
      convert_param_value_to_date(params, "postingDate")
      convert_param_value_to_date(params, "valueDate")
      convert_param_value_to_date(params, "actionDate")
      new params
    end
  end
end
