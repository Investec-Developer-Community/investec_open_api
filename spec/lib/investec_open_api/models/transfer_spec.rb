require "spec_helper"
require "investec_open_api/models/transfer"

RSpec.describe InvestecOpenApi::Models::Transfer do
  describe "#update_from_api" do
    let(:empty_transfer)  { described_class.new }
    let(:date_string)     { DateTime.current.strftime('%m/%d/%Y') }

    let(:api_params) do
      {
        "TransferResponses" => [
          {
            "PaymentReferenceNumber" => "ABC123456",
            "PaymentDate" => date_string,
            "Status" => "- Payment/Transfer effective date #{date_string}",
            "BeneficiaryName" => "Test",
            "BeneficiaryAccountId" => "12345678",
            "AuthorisationRequired" => false
          }
        ],
        "ErrorMessage" => "Sample Error"
      }
    end

    it "updates the attributes based on the response" do
      empty_transfer.assign_from_api(api_params)

      expect(empty_transfer.beneficiary_account_id).to    eq("12345678")
      expect(empty_transfer.error_message).to             eq("Sample Error")
      expect(empty_transfer.payment_date).to              eq(date_string)
      expect(empty_transfer.payment_reference_number).to  eq("ABC123456")
      expect(empty_transfer.status).to                    eq("- Payment/Transfer effective date #{date_string}")
    end

  end
end
