require "spec_helper"

RSpec.describe InvestecOpenApi::Models::Base do
  describe "#from_api" do
    it "returns a new instance of InvestecOpenApi::Models::Base without attributes" do
      model_instance = InvestecOpenApi::Models::Base.from_api

      expect(model_instance.attributes).to be_empty
    end
  end
end
