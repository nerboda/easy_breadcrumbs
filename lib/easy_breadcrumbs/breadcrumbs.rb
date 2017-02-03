require 'erubis'
require 'active_support/inflector/methods'

module EasyBreadcrumbs
  # Breadcrumb class. Converts a URL path into Bootstrap breadcrumbs
  class Breadcrumbs
    include ActiveSupport::Inflector

    def initialize(settings)
      path = settings.fetch(:request_path)

      @directories = path.scan(%r{\/[^\/]+})
      @routes = settings.fetch(:route_matchers)
      @view_variables = settings.fetch(:view_variables)
      @links = []

      build_breadcrumbs!
    end

    def to_html
      path = File.expand_path('../../assets/breadcrumbs.eruby', __FILE__)
      template = File.read(path)

      eruby = Erubis::Eruby.new(template)
      eruby.result(binding)
    end

    private

    Breadcrumb = Struct.new(:path, :text)

    def build_breadcrumbs!
      @directories.each_with_index do |directory, index|
        full_path = @directories[0..index].join

        if defined_route?(full_path)
          anchor_text = to_anchor_text(directory, index)
          @links << Breadcrumb.new(full_path, anchor_text)
        end
      end
    end

    def to_anchor_text(directory, index)
      if directory =~ /\d/
        format_for_specific_resource(index)
      elsif %w[/edit /new].include?(directory)
        format_with_view_prefix(directory, index)
      else
        clean_and_capitalize(directory)
      end
    end

    def format_for_specific_resource(index)
      previous_directory = @directories[index - 1]
      cleaned = previous_directory.delete('/')
      resource_name = singularize(cleaned)

      name_attribute_value = nil

      if variable_set?(resource_name)
        resource = find_variable(resource_name)
        resource_value = resource[:value]
        name_attribute_value = fetch_name_attribute_value(resource_value)
      end

      name_attribute_value || resource_name.capitalize
    end

    def fetch_name_attribute_value(resource_value)
      common_name_attributes = %i[name title subject]

      name_attribute = common_name_attributes.find do |method|
        resource_value.respond_to?(:method)
      end

      return resource_value[name_attribute] if name_attribute

      name_attribute = common_name_attributes.find do |key|
        resource_value[key]
      end

      resource_value[name_attribute] if name_attribute
    end

    def format_with_view_prefix(directory, index)
      previous_index = directory == '/edit' ? index - 2 : index - 1
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

    def variable_set?(resource_name)
      @view_variables.any? { |var| var[:name] == resource_name.to_sym }
    end

    def find_variable(resource_name)
      @view_variables.find { |var| var[:name] == resource_name.to_sym }
    end
  end
end
