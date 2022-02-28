module InvestecOpenApi::Models
  class Account < Base
    attribute :id
    attribute :number
    attribute :name
    attribute :reference_name
    attribute :product_name
    attribute :available_balance
    attribute :current_balance

    def self.from_api(params = {})
      if params['accountId'].present?
        params['id'] = params['accountId']
      end

      if params['accountNumber'].present?
        params['number'] = params['accountNumber']
      end

      if params['accountName'].present?
        params['name'] = params['accountName']
      end

      super
    end
  end
end
