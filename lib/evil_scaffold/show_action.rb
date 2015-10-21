module EvilScaffold
  module ShowAction
    def self.define_show kls, model_name
      kls.class_eval "def show_html; render layout: !request.xhr?; end", __FILE__, __LINE__
      kls.class_eval "def show_xls; end", __FILE__, __LINE__
      kls.class_eval "def show_vcf; end", __FILE__, __LINE__
      kls.class_eval "def show_pdf; end", __FILE__, __LINE__
      kls.class_eval <<ACTION, __FILE__, __LINE__
        def show_yaml
          exporter = Protopack::Exporter.new
          hsh      = exporter.to_package @#{model_name}
          send_data exporter.clean_yaml(hsh), filename: "#{model_name}-\#{hsh['id']}-item.yaml"
        end

        def show
          respond_to do |format|
            format.html { show_html }
            format.xls  { show_xls  }
            format.vcf  { show_vcf  }
            format.pdf  { show_pdf  }
            format.yaml { show_yaml }
          end
        end
ACTION
    end
  end
end
