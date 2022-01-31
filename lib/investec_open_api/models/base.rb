require "active_attr"

module InvestecOpenApi::Models
  class Base
    include ActiveAttr::Model

    def self.from_api(params = {})
      new(underscored_params(params))
    end

    def self.update_from_api(params = {})
      assign_attributes(underscored_params(params))
    end

    private

    def underscored_params(params)
      params.deep_transform_keys do |key|
        key.underscore.to_sym
      end
    end

    def assign_attributes(attributes)
      attributes.each do |key, value|
        raise ActiveAttr::UnknownAttributeError unless defined?(key)

        self.send("#{key}=", value)
      end

      self
    end
  end
end
