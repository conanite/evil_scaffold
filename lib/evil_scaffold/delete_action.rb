module EvilScaffold
  DeleteAction = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :delete

      config.install <<ACTION, __FILE__, __LINE__
        def delete
          render layout: !request.xhr?
        end
ACTION
    end
  end
end
