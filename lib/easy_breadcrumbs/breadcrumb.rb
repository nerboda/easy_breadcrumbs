require 'erubis'
require 'active_support/inflector/methods'

module EasyBreadcrumbs
  # Breadcrumb class. Converts a URL path into Bootstrap breadcrumbs
  class Breadcrumb
    include ActiveSupport::Inflector

    def initialize(request_path, route_matchers)
      @routes = route_matchers
      @directories = request_path.scan(%r{\/[^\/]+})
      @links = []

      build_links!
    end

    def to_html
      path = File.expand_path('../../assets/breadcrumbs.eruby', __FILE__)
      template = File.read(path)

      eruby = Erubis::Eruby.new(template)
      eruby.result(binding)
    end

    private

    Link = Struct.new(:path, :text)

    def build_links!
      @directories.each_with_index do |directory, index|
        full_path = @directories[0..index].join

        if defined_route?(full_path)
          anchor_text = to_anchor_text(directory, index)
          @links << Link.new(full_path, anchor_text)
        end
      end
    end

    def to_anchor_text(directory, index)
      if directory =~ /\d/
        previous_directory = @directories[index - 1]
        text_for_anchor = clean_and_capitalize(previous_directory)
        singularize(text_for_anchor)
      else
        clean_and_capitalize(directory)
      end
    end

    def clean_and_capitalize(directory)
      directory.delete('/').capitalize
    end

    def defined_route?(path)
      @routes.any? { |route| path =~ route }
    end
  end
end
