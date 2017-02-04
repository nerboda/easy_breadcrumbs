require 'erubis'
require 'active_support/inflector/methods'

require_relative 'breadcrumb'
require_relative 'directory'

module EasyBreadcrumbs
  # Breadcrumbs class: Converts a URL path into Bootstrap breadcrumbs.
  class Breadcrumbs
    include ActiveSupport::Inflector

    TEMPLATE = 'breadcrumbs.eruby'

    def initialize(configuration)
      @view_variables = configuration.view_variables
      @routes = configuration.route_matchers
      @path = configuration.request_path

      @directories = []
      @breadcrumbs = []

      build_directories!
      build_breadcrumbs!
    end

    def to_html
      path = File.expand_path('../../assets/' + TEMPLATE, __FILE__)
      template = File.read(path)
      eruby = Erubis::Eruby.new(template)

      eruby.result(binding)
    end

    private

    attr_reader :view_variables, :routes, :path,
                :directories, :breadcrumbs

    def build_directories!
      parsed = path.scan(%r{\/[^\/]+})

      parsed.map.with_index do |current, index|
        full_path = parsed[0..index].join
        name = current.delete('/')
        resource = fetch_variable_value(name)

        data = { full_path: full_path, name: name,
                 resource: resource, index: index }

        @directories << Directory.new(data)
      end
    end

    def build_breadcrumbs!
      directories.each do |directory|
        next unless defined_route?(directory.full_path)
        @breadcrumbs << Breadcrumb.new(directories, directory)
      end
    end

    def defined_route?(path)
      routes.any? { |route| path =~ route }
    end

    def fetch_variable_value(resource_name)
      symbol = singularize(resource_name).to_sym
      variable = view_variables.find { |var| var[:name] == symbol }

      variable[:value] if variable
    end
  end
end
