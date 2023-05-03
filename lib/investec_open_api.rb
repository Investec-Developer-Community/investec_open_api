require "investec_open_api/version"
require "investec_open_api/models/base"
require "investec_open_api/client"

module InvestecOpenApi
  class Error < StandardError; end

  mattr_accessor :api_key, :client_id, :client_secret, :scope

  def self.configuration(&block)
    yield self
  end
end
