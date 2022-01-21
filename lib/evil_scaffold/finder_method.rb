module EvilScaffold
  class Configuration
    attr_accessor :finder_filter_actions
    def find_for names
      self.finder_filter_actions += names
    end
  end

  FinderMethod = EvilScaffold.add_generator do
    def self.prepare config
      config.finder_filter_actions = %i{ show edit update delete destroy }
    end

    def self.install config
      return unless config.for? :finder

      finder = "find_#{config.model_name}"
      config.install <<FILTER, __FILE__, __LINE__

        # override this to do something with your model after you've found it. @#{config.model_name} should be set at this point.
        def after_#{finder}; end

        def #{finder}
          @#{config.model_name} = #{config.model_class_name}.find params[:id]
          after_#{finder}
        end

        # #subject is just a standardised alias for @#{config.model_name}
        def subject
          @#{config.model_name}
        end

        protected :after_#{finder}, :#{finder}, :subject
        before_action :#{finder}, only: #{config.finder_filter_actions.inspect}
FILTER
    end
  end
end
