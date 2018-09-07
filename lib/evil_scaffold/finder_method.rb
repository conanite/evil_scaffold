module EvilScaffold
  class Configuration
    attr_accessor :finder_filter_actions
  end

  FinderMethod = EvilScaffold.add_generator do
    def self.prepare config
      config.finder_filter_actions = %i{ show edit update delete destroy }
    end

    def self.install config
      return unless config.for? :finder

      finder = "find_#{config.model_name}"
      config.install <<FILTER, __FILE__, __LINE__
        protected

        def after_#{finder}; end

        def #{finder}
          @#{config.model_name} = #{config.model_class_name}.find params[:id]
          after_#{finder}
        end

        def subject
          @#{config.model_name}
        end

        before_filter :#{finder}, only: #{config.finder_filter_actions.inspect}
FILTER
    end
  end
end
