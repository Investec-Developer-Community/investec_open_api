# frozen_string_literal: true

module InvestecOpenApi::Models
  class Balance < Base
    attr_reader :id,
                :current_balance,
                :available_balance,
                :budget_balance,
                :straight_balance,
                :cash_balance,
                :currency

    def self.from_api(params = {})
      rewrite_param_key(params, "accountId", "id")

      convert_param_value_to_money(params, "currentBalance")
      convert_param_value_to_money(params, "availableBalance")
      convert_param_value_to_money(params, "budgetBalance")
      convert_param_value_to_money(params, "straightBalance")
      convert_param_value_to_money(params, "cashBalance")

      new params
    end
  end
end
