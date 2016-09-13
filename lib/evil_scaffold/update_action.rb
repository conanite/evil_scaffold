module EvilScaffold
  module UpdateAction
    def self.install kls, names, model_name
      kls.class_eval <<ACTION, __FILE__, (__LINE__ + 1)
        def ajax_after_update
          render "ajax_update", layout: false
        end

        def update
          if @#{model_name}.update_attributes params[:#{model_name}].permit!
            if request.xhr?
              ajax_after_update
            else
              return_appropriately
            end
          else
            raise "save failed : \#{@#{model_name}.errors.to_yaml}"
          end
        end
ACTION
    end
  end
end
