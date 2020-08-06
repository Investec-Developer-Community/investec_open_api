RSpec.describe InvestecOpenApi::Models::Account do
  describe "#from_api" do
    context "with valid attributes" do
      it "returns a new instance of InvestecOpenApi::Models::Account with attributes" do
        model_instance = InvestecOpenApi::Models::Account.from_api({
          "accountId" => "12345",
          "accountNumber" => "67890",
          "accountName" => "Test User",
          "referenceName" => "Savings Account",
          "productName" => "Private Bank Account"
        })

        expect(model_instance.id).to eq "12345"
        expect(model_instance.number).to eq "67890"
        expect(model_instance.name).to eq "Test User"
        expect(model_instance.reference_name).to eq "Savings Account"
        expect(model_instance.product_name).to eq "Private Bank Account"
      end
    end

    context "with valid and invalid attributes" do
      it "returns a new instance of InvestecOpenApi::Models::Account with only valid attributes" do
        model_instance = InvestecOpenApi::Models::Account.from_api({
          "accountId" => "12345",
          "bankAccountNumber" => "67890"
        })

        expect(model_instance.id).to eq "12345"
        expect(model_instance.number).to eq nil
        expect(model_instance.name).to eq nil
        expect(model_instance.reference_name).to eq nil
        expect(model_instance.product_name).to eq nil

        expect { model_instance.bank_account_number }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#transactions" do
    let(:account) do
      InvestecOpenApi::Models::Account.from_api({
          "accountId" => "12345",
          "accountNumber" => "67890",
          "accountName" => "Test User",
          "referenceName" => "Savings Account",
          "productName" => "Private Bank Account"
        })
    end

    it "responds to #transactions" do
      expect(account.respond_to?(:transactions)).to be_truthy
    end
  end

  describe ".find" do
    xit "finds an account by its id"

    it "raises a NotFoundError if no account is found" do
      expect{described_class.find(1)}.to raise_error(InvestecOpenApi::MethodNotImplementedError)
    end
  end

  describe ".all" do
    it "queries all accessible accounts" do
      expect_any_instance_of(InvestecOpenApi::Client).to receive(:accounts)
      described_class.all
    end
  end
end
