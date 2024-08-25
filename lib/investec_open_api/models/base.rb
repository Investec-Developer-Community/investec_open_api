require_relative "../string_utilities"

module InvestecOpenApi::Models
  using InvestecOpenApi::StringUtilities

  class Base
    def initialize(params)
      params
        .transform_keys(&:underscore)
        .each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def self.rewrite_param_key(params, key, rewritten_key)
      params[rewritten_key] = params[key] unless params[key].nil?
    end

    def self.convert_param_value_to_money(
      params,
      key,
      currency_key = "currency",
      should_make_negative = false
    )
      if params[key].nil?
        return
      end
      value_in_cents = params[key] * 100
      value_in_cents = -value_in_cents if should_make_negative
      params[key] = Money.from_cents(
        value_in_cents,
        params[currency_key])
    end

    def self.convert_param_value_to_date(params, key)
      params[key] = Date.parse(params[key]) unless params[key].nil?
    end
  end
end
