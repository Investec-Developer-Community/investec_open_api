require "investec_open_api/version"
require "investec_open_api/client"
require "investec_open_api/exceptions/method_not_implemented_error"
require "investec_open_api/exceptions/not_found_error"
require "investec_open_api/models/relations"
require "investec_open_api/models/base"
require "investec_open_api/models/account"
require "investec_open_api/models/transaction"

module InvestecOpenApi
  class Error < StandardError; end

  class << self
    mattr_accessor :api_url, :api_username, :api_password, :scope
  end

  def self.configuration(&block)
    yield self
  end
end
