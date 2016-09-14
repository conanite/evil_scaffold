module EvilScaffold
  GotoShowMethod = EvilScaffold.add_generator do
    def self.install config
      return unless config.for? :goto_show

      method_name = "back_to_#{config.model_name}"
      config.install <<ACTION, __FILE__, __LINE__
        def #{method_name}
          redirect_to action: :show, id: @#{config.model_name}.id
        end
        protected :#{method_name}
ACTION
    end
  end
end
