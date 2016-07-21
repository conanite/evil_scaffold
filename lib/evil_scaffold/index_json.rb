module EvilScaffold
  module IndexJson
    def self.define_index_json kls, model_name, models_name
      item_to_json = "#{model_name}_to_json"
      code = <<INDEX_JSON
        protected

        def #{item_to_json} item
          { id: item.id, text: item.name }
        end

        def index_json
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
      kls.class_eval code
    end
  end
end
