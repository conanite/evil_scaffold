module EvilScaffold
  module DestroyAction
    def self.install kls, model_name, path_to_avoid_after_delete
      avoidance_clause = <<AVOIDANCE
        wrong_url = #{path_to_avoid_after_delete}_path(@#{model_name})
        if params[:return_to] == wrong_url
          redirect_to action: :index
        else
          back
        end
AVOIDANCE

      back_instruction = if path_to_avoid_after_delete.present?
        avoidance_clause
      else
        "back"
      end

      kls.class_eval <<ACTION, __FILE__, __LINE__
        def ajax_after_destroy
          render "ajax_destroy", layout: false
        end

        def destroy
          @#{model_name}.destroy
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
