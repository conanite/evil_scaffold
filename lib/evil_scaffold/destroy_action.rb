module EvilScaffold
  class Configuration
    attr_accessor :avoid_after_delete
    def delete_avoid name
      self.avoid_after_delete = name
    end
  end

  DestroyAction = EvilScaffold.add_generator do
    def self.prepare config
      name                      = config.klass.name
      show_path                 = name.underscore.sub(/_controller$/, '').gsub("/", "_").singularize
      config.avoid_after_delete = show_path
    end

    def self.install config
      return unless config.for? :destroy

      avoidance_clause = <<AVOIDANCE
        wrong_url = #{config.avoid_after_delete}_path(@#{config.model_name})
        if params[:return_to] == wrong_url
          redirect_to action: :index
        else
          back
        end
AVOIDANCE

      back_instruction = if config.avoid_after_delete.present?
        avoidance_clause
      else
        "back"
      end

      config.install <<ACTION, __FILE__, __LINE__
        def ajax_after_destroy
          render "ajax_destroy", layout: false
        end

        def destroy
          @#{config.model_name}.destroy
          if request.xhr?
            ajax_after_destroy
          else
            #{back_instruction}
          end
        end
ACTION
    end
  end
end
