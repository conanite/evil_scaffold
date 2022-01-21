module EvilScaffold
  ModelParams = EvilScaffold.add_generator do
    def self.prepare config ; (config.names << :params) if config.for?(:create) || config.for?(:new) ; end # this dependency is also expressed in #create and in #new

    def self.install config
      return unless config.for? :params
      config.install <<ACTION, __FILE__, __LINE__
        # by default permits all attrs, override if you need to be more selective about your attributes
        # def sanitise_for_create attrs
        #   attrs.permit!
        # end

        # override if you're working with subclasses and you need to pick the right one (eg from params)
        def get_model_class
          #{config.model_class_name}
        end

        # override if you have a special way to create new instances. Used by #new and by #create actions
        def build_new_#{config.model_name}
          @#{config.model_name} = get_model_class.new #{config.model_name}_params
        end

        def default_#{config.model_name}_params
          ActionController::Parameters.new({}).permit!
        end

        def #{config.model_name}_params
          @__#{config.model_name}_params ||= (params[:#{config.model_name}].present? ? params[:#{config.model_name}].permit! : default_#{config.model_name}_params)
        end
ACTION
    end
  end
end
