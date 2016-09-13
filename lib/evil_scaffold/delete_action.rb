module EvilScaffold
  module DeleteAction
    def self.install kls
      kls.class_eval <<ACTION, __FILE__, __LINE__
        def delete
          render layout: !request.xhr?
        end
ACTION
    end
  end
end
