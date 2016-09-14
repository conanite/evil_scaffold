module EvilScaffold
  CreateAction = EvilScaffold.add_generator do
    def self.install config
      return unless config.for? :create
      config.install <<ACTION, __FILE__, __LINE__
        def create_validation_failure thing
          raise(ActiveRecord::RecordInvalid.new(thing))
        end

        def ajax_after_create
          render "ajax_create", layout: false
        end

        def create
          @#{config.model_name} = #{config.model_class_name}.new params[:#{config.model_name}].permit!
          if @#{config.model_name}.save
            if request.xhr?
              ajax_after_create
            else
              return_appropriately
            end
          else
            create_validation_failure @#{config.model_name}
          end
        end
ACTION
    end
  end
end
