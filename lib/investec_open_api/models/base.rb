require "active_attr"

module InvestecOpenApi::Models
  class Base
    include ActiveAttr::Model

    def self.from_api(params = {})
      new(underscored_params(params))
    end

    def assign_from_api(params = {})
      self.assign_attributes(self.class.underscored_params(params))
      self
    end

    private

    def self.underscored_params(params)
      params.deep_transform_keys do |key|
        key.underscore.to_sym
      end
    end

  end
end
