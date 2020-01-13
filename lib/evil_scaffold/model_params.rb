module EvilScaffold
  ModelParams = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :params
      config.install <<ACTION, __FILE__, __LINE__
        def #{config.model_name}_params
          @__#{config.model_name}_params ||= (params[:#{config.model_name}].present? ? params[:#{config.model_name}].permit! : {})
        end
ACTION
    end
  end
end
