require 'erubis'
require 'active_support/inflector/methods'

module EasyBreadcrumbs
  # Breadcrumb class. Converts a URL path into Bootstrap breadcrumbs
  class Breadcrumb
    include ActiveSupport::Inflector

    Link = Struct.new(:full_path, :anchor_text)

    def initialize(request_path, route_matchers)
      @routes = route_matchers
      @directories = request_path.scan(/\/[^\/]+/)
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

    def build_links!
      @directories.each_with_index do |directory, idx|
        full_path = @directories[0..idx].join

        next unless defined_route?(full_path)

        anchor_text = if directory =~ /\d/
                        previous_directory = @directories[idx - 1]
                        text_for_anchor = to_anchor_text(previous_directory)
                        singularize(text_for_anchor)
                      else
                        to_anchor_text(directory)
                      end
        @links << Link.new(full_path, anchor_text)
      end
    end

    def to_anchor_text(directory)
      directory.delete('/').capitalize
    end

    def defined_route?(path)
      @routes.any? { |route| path.match(route) }
    end
  end
end
