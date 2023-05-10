module InvestecOpenApi::Models
  class Transfer < Base
    attribute :payment_reference_number
    attribute :payment_date
    attribute :status
    attribute :beneficiary_name
    attribute :beneficiary_account_id
    attribute :authorisation_required

    def self.from_api(params = {})
      if params['PaymentReferenceNumber'].present?
        params['payment_reference_number'] = params['PaymentReferenceNumber']
      end

      if params['PaymentDate'].present?
        params['payment_date'] = params['PaymentDate']
      end

      if params['Status'].present?
        params['status'] = params['Status']
      end

      if params['BeneficiaryName'].present?
        params['beneficiary_name'] = params['BeneficiaryName']
      end

      if params['BeneficiaryAccountId'].present?
        params['beneficiary_account_id'] = params['BeneficiaryAccountId']
      end

      if params['AuthorisationRequired'].present?
        params['authorisation_required'] = params['AuthorisationRequired']
      end

      super
    end
  end
end
