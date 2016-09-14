module EvilScaffold
  module DeleteAction
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
