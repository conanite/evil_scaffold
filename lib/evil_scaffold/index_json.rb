module EvilScaffold
  module IndexJson
    def self.install config
      return unless config.for? :index_json
      item_to_json = "#{config.model_name}_to_json"
      config.install <<INDEX_JSON, __FILE__, __LINE__
        protected

        def #{item_to_json} item
          { id: item.id, text: item.name }
        end

        def index_json
          per_page = isset(:per_page) ? params[:per_page].to_i : 20
          page     = isset(:page)     ? params[:page].to_i     : 1
          @#{config.models_name}  = @#{config.models_name}.paginate page: page, per_page: per_page
          json = {
            results: @#{config.models_name}.map { |item| #{config.model_name}_to_json item },
            pagination: { more: (page * per_page) < @#{config.models_name}.total_entries }
          }
          render json: json
        end
INDEX_JSON
    end
  end
end
