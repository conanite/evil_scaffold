module EvilScaffold
  module IndexJsonMethod
    def self.define_index_json kls, model_name, models_name
      index_json = "#{model_name}_to_json"
      kls.class_eval <<INDEX_JSON
        protected

        def #{index_json} item
          per_page = isset(:per_page) ? params[:per_page].to_i : 20
          page     = isset(:page)     ? params[:page].to_i     : 1
          @#{models_name}  = @#{models_name}.paginate page: page, per_page: per_page
          json = {
            results: @#{models_name}.map { |item| #{model_name}_to_json item },
            pagination: { more: (page * per_page) < @#{models_name}.total_entries }
          }
          render json: json
        end
INDEX_JSON
    end
  end
end
