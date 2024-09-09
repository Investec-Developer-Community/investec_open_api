require "investec_open_api/version"
require "investec_open_api/models/base"
require "investec_open_api/camel_case_refinement"
require "investec_open_api/client"

module InvestecOpenApi
  class Error < StandardError; end

  class Configuration
    DEFAULT_BASE_URL = "https://openapi.investec.com/"

    attr_accessor :api_key,
                  :client_id,
                  :client_secret,
                  :scope,
                  :base_url

    def initialize
      @base_url = DEFAULT_BASE_URL

      Money.locale_backend = :i18n
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configuration
      yield config
    end
  end
end
