module EvilScaffold
  EditAction = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :edit
      config.install <<ACTION, __FILE__, __LINE__
        def edit
          render layout: !request.xhr?
        end
ACTION
    end
  end
end
