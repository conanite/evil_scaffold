module EvilScaffold
  module CreateAction
    def self.install kls, model_name, model_class_name
        kls.class_eval <<ACTION, __FILE__, __LINE__
          def create_validation_failure thing
            raise(ActiveRecord::RecordInvalid.new(thing))
          end

          def ajax_after_create
            render "ajax_create", layout: false
          end

          def create
            @#{model_name} = #{model_class_name}.new params[:#{model_name}].permit!
            if @#{model_name}.save
              if request.xhr?
                ajax_after_create
              else
                return_appropriately
              end
            else
              create_validation_failure @#{model_name}
            end
          end
ACTION
    end
  end
end
