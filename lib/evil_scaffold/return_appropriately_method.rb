module EvilScaffold
  ReturnAppropriatelyMethod = EvilScaffold.add_generator do
    def self.install config
      config.install <<MAYBE_BACK, __FILE__, __LINE__
        def return_appropriately
          if params[:return_to]
            back
          else
            back_to_#{config.model_name}
          end
        end
MAYBE_BACK
    end
  end
end
