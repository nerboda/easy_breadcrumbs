require 'easy_breadcrumbs/detect_name'
require 'active_support/inflector/methods'

module EasyBreadcrumbs
  # Breadcrumb class properly formats it's data depending on:
  # => Where within the set of breadcrumbs it falls
  # => Whether it's a path to a specific resource
  # => Whether it's a path to a `new` or `edit` view
  class Breadcrumb
    include ActiveSupport::Inflector
    include EasyBreadcrumbs::DetectName

    attr_reader :path, :text

    def initialize(directories, directory)
      @directories = directories
      @directory = directory

      @path = directory.full_path
      @text = format_anchor_text
    end

    private

    attr_reader :directories, :directory

    def format_anchor_text
      return specific_resource if directory.ends_in_digit?
      return with_view_prefix if directory.new_or_edit_view?

      directory.name.capitalize
    end

    def specific_resource
      previous_directory = other_directory(-1)

      if previous_directory.resource
        detect_name(previous_directory.resource)
      else
        singularize(previous_directory.name).capitalize
      end
    end

    def with_view_prefix
      relative_index = directory.edit_view? ? -2 : -1
      previous_directory = other_directory(relative_index)
      view_prefix = directory.name.capitalize
      rest_of_anchor = singularize(previous_directory.name).capitalize

      "#{view_prefix} #{rest_of_anchor}"
    end

    def other_directory(relative_index)
      directories[directory.index + relative_index]
    end
  end
end
