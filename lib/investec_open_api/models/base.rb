require "active_attr"

module InvestecOpenApi::Models
  class Base
    include ActiveAttr::Model

    def self.from_api(params = {})
      underscored_params = params.deep_transform_keys do |key|
        key.underscore.to_sym
      end

      new(underscored_params)
    end
  end
end
