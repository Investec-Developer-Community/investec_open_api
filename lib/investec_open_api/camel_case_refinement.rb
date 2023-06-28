module InvestecOpenApi
  module CamelCaseRefinement
    refine Hash do
      def camelize
        transform_keys do |key|
          words = key.to_s.split('_')
          words.drop(1).collect(&:capitalize).unshift(words.first).join
        end
      end
    end
  end
end
