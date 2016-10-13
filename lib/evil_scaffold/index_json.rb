module EvilScaffold
  IndexJson = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :index_json
      item_to_json = "#{config.model_name}_to_json"
      config.install <<INDEX_JSON, __FILE__, __LINE__
        protected

        def #{item_to_json} item
          { id: item.id, text: item.name }
        end

        def index_json_optgroups items
          nil
        end

        def index_json_per_page
          20
        end

        def index_json
          per_page                = isset(:per_page) ? params[:per_page].to_i : index_json_per_page
          page                    = isset(:page)     ? params[:page].to_i     : 1
          @#{config.models_name}  = @#{config.models_name}.paginate page: page, per_page: per_page
          optgroups               = index_json_optgroups @#{config.models_name}
          results                 = if optgroups.nil?
                                       @#{config.models_name}.map { |item| #{config.model_name}_to_json item }
                                    else
                                      optgroups.map { |grouping, items|
                                        { text: grouping, children: items.map { |item| #{item_to_json} item } }
                                      }
                                    end
          pagination              = { more: (page * per_page) < @#{config.models_name}.total_entries }
          render json: { results: results, pagination: pagination }
        end
INDEX_JSON
    end
  end
end
