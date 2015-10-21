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
    def index_per_page               ; 20           ; end
    def index_xhr_view_template      ; "index_ajax" ; end

    def index_paginate items
      items.paginate(:per_page => index_per_page, :page => params[:page] || 1)
    end
  end

  module IndexAction
    def self.define_index kls, no_filter, ordering_scope, models_name, model_class_name
      if ordering_scope
        ordinal_clause =  <<ORDINAL
          @#{models_name} = @#{models_name}.#{ordering_scope}
ORDINAL
      else
        ordinal_clause =  ""
      end

      if no_filter
        filter_invocation = "@#{models_name} = #{model_class_name}.all"
      else
        filter_invocation = "@#{models_name} = filter_#{models_name}(#{model_class_name}.all)"
        kls.class_eval <<ACTION, __FILE__, __LINE__
          def filter_#{models_name} items
            items
          end
          protected :filter_#{models_name}
ACTION
      end

      kls.class_eval <<ACTION, __FILE__, __LINE__
        include EvilScaffold::IndexActionHelpers

        def index_html
          @#{models_name}_count = @#{models_name}.size
          return if !request.xhr? && (@#{models_name}_count == 1) && (handle_unique_result(@#{models_name}.first))

          index_pre_render

          @#{models_name} = with_eager_includes(@#{models_name})
          #{ordinal_clause}
          @unpaginated_#{models_name} = @#{models_name}
          @#{models_name} = index_paginate(@#{models_name})

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
            format.xls { index_xls }
            format.pdf { index_pdf }
            format.html { index_html }
          end
        end
ACTION
    end
  end
end
