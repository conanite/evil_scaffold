module EvilScaffold
  module FinderMethod
    def self.define_finder kls, model_name, model_class_name, finder_filter_actions
      finder = "find_#{model_name}"
      kls.class_eval <<FILTER
        protected

        def after_#{finder}; end

        def #{finder}
          @#{model_name} = #{model_class_name}.find params[:id]
          after_#{finder}
        end
FILTER

      kls.before_filter finder.to_sym, only: finder_filter_actions
    end
  end
end
