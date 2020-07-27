require "spec_helper"
require "investec_open_api/client"

RSpec.describe InvestecOpenApi::Client do
 
  before do
    InvestecOpenApi.api_url = "https://openapistg.investec.com/"
    InvestecOpenApi.api_username = "Test"
    InvestecOpenApi.api_password = "Secret"
  end

  describe "#authenticate!" do
    context "when the credentials are correct" do
      before do
        stub_request(:any, "#{InvestecOpenApi.api_url}identity/v2/oauth2/token")
          .with(body: {
            grant_type: "client_credentials",
            scope: "accounts"
          }.to_query, 
          headers: {"Content-Type" => "application/json"}).
          .to_return(body: %q("access_token":"123","token_type":"Bearer","expires_in":1799,"scope":"accounts"))
      end
      
      it "should return a valid access token" do
        api = InvestecOpenApi.new
        expect(api.authenticate!).to eq %q"access_token":"123","token_type":"Bearer","expires_in":1799,"scope":"accounts")
      end  
    end

    context "when the credentials are invalid" do
      it "should return a 400 error" do
        
      end  
    end
  end
 
  describe "#accounts" do
    
  end
 
  describe "#transactions" do
    
  end
end
