module EvilScaffold
  module NewAction
    def self.install kls, model_name
      kls.class_eval <<ACTION, __FILE__, __LINE__
        def build_new_#{model_name}
        end

        def new
          build_new_#{model_name}
          render layout: !request.xhr?
        end
ACTION
    end
  end
end
