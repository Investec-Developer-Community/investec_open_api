RSpec.describe InvestecOpenApi do
  it "has a version number" do
    expect(InvestecOpenApi::VERSION).not_to be nil
  end

  context("configuration") do
    it "should set the configuration variables that the sdk needs" do
      allow(InvestecOpenApi::Client).to receive(:configure)
      InvestecOpenApi.configuration do |config|
        config.api_key = "api_key"
        config.client_id = "client_id"
        config.client_secret = "client_secret"
        config.base_url = "https://openapisandbox.investec.com/"
      end
      expect(InvestecOpenApi.config.api_key).to eq("api_key")
      expect(InvestecOpenApi.config.client_id).to eq("client_id")
      expect(InvestecOpenApi.config.client_secret).to eq("client_secret")
      expect(InvestecOpenApi.config.base_url).to eq("https://openapisandbox.investec.com/")
    end
  end
end
