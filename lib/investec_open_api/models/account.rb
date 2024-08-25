module InvestecOpenApi::Models
  class Account < Base
    attr_reader :id,
                :number,
                :name,
                :reference_name,
                :product_name,
                :kyc_compliant,
                :profile_id,
                :profile_name

    def self.from_api(params = {})
      rewrite_param_key(params, "accountId", "id")
      rewrite_param_key(params, "accountNumber", "number")
      rewrite_param_key(params, "accountName", "name")
      new params
    end
  end
end
