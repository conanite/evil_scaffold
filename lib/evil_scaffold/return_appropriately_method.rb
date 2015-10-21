module EvilScaffold
  module ReturnAppropriatelyMethod
    def self.define_return_appropriately kls, model_name
      kls.class_eval <<MAYBE_BACK, __FILE__, __LINE__
        def return_appropriately
          if params[:return_to]
            back
          else
            back_to_#{model_name}
          end
        end
MAYBE_BACK
    end
  end
end
