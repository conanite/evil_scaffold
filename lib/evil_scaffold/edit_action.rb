module EvilScaffold
  module EditAction
    def self.install kls
      kls.class_eval <<ACTION, __FILE__, __LINE__
        def edit
          render layout: !request.xhr?
        end
ACTION
    end
  end
end
