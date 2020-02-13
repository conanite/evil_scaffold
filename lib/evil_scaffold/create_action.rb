module EvilScaffold
  CreateAction = EvilScaffold.add_generator do
    def self.prepare config ; config.names << :params ; end  # this dependency is also expressed in #params

    def self.install config
      return unless config.for? :create
      config.install <<ACTION, __FILE__, __LINE__
        # override this to respond appropriately in case of a validation error
        def create_validation_failure thing
          raise(ActiveRecord::RecordInvalid.new(thing))
        end

        # override this and raise an error if thing cannot be created for any reason other than validation error
        # or return something else that responds to #save if this #thing is not the thing that should be created
        def authorise_creation thing
          thing
        end

        # this is called after #create for any xhr request
        def ajax_after_create
          render "ajax_create", layout: false
        end

        # this is the #create action
        def create
          @#{config.model_name} = authorise_creation build_new_#{config.model_name}
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
