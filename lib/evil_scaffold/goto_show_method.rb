module EvilScaffold
  module GotoShowMethod
    def self.install kls, model_name
      method_name = "back_to_#{model_name}"
      kls.class_eval <<ACTION, __FILE__, __LINE__
        def #{method_name}
          redirect_to action: :show, id: @#{model_name}.id
        end
        protected :#{method_name}
ACTION
    end
  end
end
