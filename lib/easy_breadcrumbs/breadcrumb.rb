require 'erubis'
require 'active_support/inflector/methods'

module EasyBreadcrumbs
  # Breadcrumb class. Converts a URL path into Bootstrap breadcrumbs
  class Breadcrumb
    include ActiveSupport::Inflector

    def initialize(request_path, route_matchers, options = {})
      @configuration = options
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
        format_for_specific_resource(index)
      elsif %w(/edit /new).include?(directory)
        format_with_view_prefix(directory, index)
      else
        clean_and_capitalize(directory)
      end
    end

    def format_for_specific_resource(index)
      previous_directory = @directories[index - 1]
      text_for_anchor = clean_and_capitalize(previous_directory)
      singularize(text_for_anchor)
    end

    def format_with_view_prefix(directory, index)
      previous_index = directory == "/edit" ? index - 2 : index - 1
      previous_directory = @directories[previous_index]
      
      view_prefix = clean_and_capitalize(directory)
      rest_of_anchor = clean_and_capitalize(previous_directory)
      singularized = singularize(rest_of_anchor)
      
      "#{view_prefix} #{singularized}"
    end

    def clean_and_capitalize(directory)
      directory.delete('/').capitalize
    end

    def defined_route?(path)
      @routes.any? { |route| path =~ route }
    end
  end
end
