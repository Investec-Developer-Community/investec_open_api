require "investec_open_api/version"
require "investec_open_api/models/base"

module InvestecOpenApi
  class Error < StandardError; end

  class << self
    mattr_accessor :api_url, :api_username, :api_password, :scope
  end

  def self.configuration(&block)
    yield self
  end
end
