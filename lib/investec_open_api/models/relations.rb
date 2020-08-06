module InvestecOpenApi::Models
  module Relations
    extend self

    class RelationshipError < StandardError; end

    def has_many(relation, params)
      raise RelationshipError, "A valid class_name is required" unless params[:class_name]

      self.define_method(relation) do
        klass = Object.const_get("#{self.class.module_parent}::#{params[:class_name]}")
        klass.where("#{self.class.to_s.split("::")[-1].downcase}_id".to_sym => self.id)
      end
    end

    def belongs_to(relation, params)
      raise RelationshipError, "A valid class_name is required" unless params[:class_name]

      self.define_method(relation) do
        klass = Object.const_get("#{self.class.module_parent}::#{params[:class_name]}")
        klass.find(self.send("#{relation}_id".to_sym))
      end
    end
  end
end
