require 'active_support/inflector/methods'

module EasyBreadcrumbs
  class PathSet
    include ActiveSupport::Inflector

    Path = Struct.new(:full_path, :anchor_text)

    def initialize(full_path, defined_routes)
      @routes = defined_routes
      @directories = full_path.scan(/\/[^\/]+/)
    end

    def to_a
      paths = []

      @directories.each_with_index do |directory, idx|
        full_path = @directories[0..idx].join
        
        if directory =~ /\d/
          text_for_anchor = @directories[idx - 1].delete("/").capitalize
          anchor_text = singularize(text_for_anchor)
        else
          anchor_text = directory.delete("/").capitalize
        end
        
        paths << Path.new(full_path, anchor_text) if is_defined?(full_path)
      end

      paths
    end

    private

    def is_defined?(path)
      @routes.any? { |route| path.match(route) }
    end
  end
end