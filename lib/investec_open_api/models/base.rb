require "active_attr"

module InvestecOpenApi::Models
  class Base
    include ActiveAttr::Model
    extend InvestecOpenApi::Models::Relations

    @@client = -> do
      client = InvestecOpenApi::Client.new
      client.authenticate!
    end

    def self.client
      @@client.call
    end

    def self.from_api(params = {})
      underscored_params = params.deep_transform_keys do |key|
        key.underscore.to_sym
      end

      new(underscored_params)
    end

    protected
    attr_accessor :client
  end
end
