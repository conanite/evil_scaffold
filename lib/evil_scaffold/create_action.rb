module EvilScaffold
  CreateAction = EvilScaffold.add_generator do
    def self.prepare config ; end

    def self.install config
      return unless config.for? :create
      config.install <<ACTION, __FILE__, __LINE__
        # by default permits all attrs, override if you need to be more selective about your attributes
        def sanitise_for_create attrs
          attrs.permit!
        end

        # override this to respond appropriately in case of a validation error
        def create_validation_failure thing
          raise(ActiveRecord::RecordInvalid.new(thing))
        end

        # override this and raise an error if thing cannot be created for any reason other than validation error
        def authorise_creation thing
          thing
        end

        # this is called after #create for any xhr request
        def ajax_after_create
          render "ajax_create", layout: false
        end

        # this is the #create action
        def create
          @#{config.model_name} = authorise_creation #{config.model_class_name}.new sanitise_for_create params[:#{config.model_name}]
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
