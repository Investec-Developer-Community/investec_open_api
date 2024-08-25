require "spec_helper"
require "investec_open_api/string_utilities"

RSpec.describe InvestecOpenApi::StringUtilities do
  using InvestecOpenApi::StringUtilities

  it "converts to underscores" do
    expected = "hello_world"
    expect('helloWorld'.underscore).to eq(expected)
  end
end
