module EvilScaffold
  UpdateAction = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :update
      config.install <<ACTION, __FILE__, (__LINE__ + 1)
        def sanitise_for_update attrs
          attrs.permit!
        end

        def ajax_after_update
          render "ajax_update", layout: false
        end

        def update
          if @#{config.model_name}.update sanitise_for_update params[:#{config.model_name}]
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
