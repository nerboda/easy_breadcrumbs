module EasyBreadcrumbs
  # Directory class makes things easier on the Breadcrumb class.
  class Directory
    attr_reader :full_path, :name, :index, :resource

    def initialize(data)
      @full_path = data.fetch(:full_path)
      @name = data.fetch(:name)
      @resource = data.fetch(:resource)
      @index = data.fetch(:index)
    end

    def root_path?
      index.zero?
    end

    def ends_in_digit?
      name =~ %r{\d+\/?$}
    end

    def new_view?
      name == 'new'
    end

    def edit_view?
      name == 'edit'
    end

    def new_or_edit_view?
      new_view? || edit_view?
    end
  end
end
