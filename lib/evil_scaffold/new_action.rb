module EvilScaffold
  NewAction = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :new
      config.install <<ACTION, __FILE__, __LINE__
        def build_new_#{config.model_name}
        end

        def new
          build_new_#{config.model_name}
          render layout: !request.xhr?
        end
ACTION
    end
  end
end
