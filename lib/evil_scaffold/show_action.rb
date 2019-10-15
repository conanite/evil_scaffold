module EvilScaffold
  ShowAction = EvilScaffold.add_generator do
    def self.prepare config ; end
    def self.install config
      return unless config.for? :show
      config.install "def show_html; render layout: !request.xhr?; end", __FILE__, __LINE__
      config.install "def show_xls; end", __FILE__, __LINE__
      config.install "def show_vcf; end", __FILE__, __LINE__
      config.install "def show_pdf; end", __FILE__, __LINE__
      config.install "def show_zip; end", __FILE__, __LINE__
      config.install <<ACTION, __FILE__, __LINE__ + 1
        def show_yaml
          exporter = Protopack::Exporter.new
          hsh      = exporter.to_package @#{config.model_name}
          send_data exporter.clean_yaml(hsh), filename: "#{config.model_name}-\#{hsh['id'].gsub(/\s/, '-')}-item.yaml"
        end

        def show_txt
          if @#{config.model_name}.respond_to? :to_text
            send_data @#{config.model_name}.to_text
          else
            raise NotFound
          end
        end

        def show
          respond_to do |format|
            format.html { show_html }
            format.xls  { show_xls  }
            format.vcf  { show_vcf  }
            format.pdf  { show_pdf  }
            format.yaml { show_yaml }
            format.zip  { show_zip  }
            format.text { show_txt  }
          end
        end
ACTION
    end
  end
end
