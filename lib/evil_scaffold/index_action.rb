module EvilScaffold
  module IndexActionHelpers
    protected

    def index_xls
      response.headers["Content-Type"] = "application/vnd.ms-excel;charset=iso-8859-1"
      response.headers["charset"]      = 'iso-8859-1'
    end

    def handle_unique_result results ; false        ; end
    def with_eager_includes results  ; results      ; end
    def index_pre_render             ;                end
    def index_per_page               ; 50           ; end

    def index_paginate items
      items.paginate(:per_page => index_per_page, :page => params[:page] || 1)
    end
  end

  IndexAction = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :index

      if config.ordering_scope
        ordinal_clause =  <<ORDINAL
          @#{config.models_name} = @#{config.models_name}.#{config.ordering_scope}
ORDINAL
      else
        ordinal_clause =  ""
      end

      if config.no_filter
        filter_invocation = "@#{config.models_name} = #{config.model_class_name}.all"
      else
        filter_invocation = "@#{config.models_name} = filter_#{config.models_name}(#{config.model_class_name}.all)"
        config.install <<ACTION, __FILE__, __LINE__
          def filter_#{config.models_name} items
            items
          end
          protected :filter_#{config.models_name}
ACTION
      end

      config.install <<ACTION, __FILE__, __LINE__
        include EvilScaffold::IndexActionHelpers

        def index_xhr_view_template
          "index_ajax"
        end unless method_defined?(:index_xhr_view_template)

        def index_html
          @#{config.models_name}_count = @#{config.models_name}.size
          return if !request.xhr? && (@#{config.models_name}_count == 1) && (handle_unique_result(@#{config.models_name}.first))

          index_pre_render

          @#{config.models_name} = with_eager_includes(@#{config.models_name})
          #{ordinal_clause}
          @unpaginated_#{config.models_name} = @#{config.models_name}
          @#{config.models_name} = index_paginate(@#{config.models_name})

          if request.xhr?
            render index_xhr_view_template, layout: false
          end
        end

        def filter_for_index
          #{filter_invocation}
        end

        def index
          filter_for_index
          respond_to do |format|
            format.zip  { index_zip }
            format.json { index_json }
            format.xls  { index_xls  }
            format.pdf  { index_pdf  }
            format.html { index_html }
          end
        end
ACTION
    end
  end
end
