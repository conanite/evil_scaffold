module EvilScaffold
  module UpdateAction
    def self.install config
      return unless config.for? :update
      config.install <<ACTION, __FILE__, (__LINE__ + 1)
        def ajax_after_update
          render "ajax_update", layout: false
        end

        def update
          if @#{config.model_name}.update_attributes params[:#{config.model_name}].permit!
            if request.xhr?
              ajax_after_update
            else
              return_appropriately
            end
          else
            raise "save failed : \#{@#{config.model_name}.errors.to_yaml}"
          end
        end
ACTION
    end
  end
end
