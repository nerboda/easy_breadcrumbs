require_relative "pathset"

module EasyBreadcrumbs
  class Breadcrumb
    def initialize(request_path, routes)
      @paths = PathSet.new(request_path, routes).to_a
    end

    def to_html
      list_items = format_list_items(@paths)
      <<~HTML.chomp
        <ol class=\"breadcrumb\">
        <li class=\"breadcrumb-item\"><a href=\"/\">Home</a></li>
        #{list_items}
        </ol>
      HTML
    end

    private

    def format_list_items(paths)
      list_items = paths.map do |path|
        if path.full_path == paths.last.full_path
          active_list_item(path.anchor_text)
        else
          link_list_item(path.full_path, path.anchor_text)
        end
      end

      list_items.join("\n")
    end

    def format_anchor_text(directory)
      directory.delete("/").capitalize
    end

    def link_list_item(link, anchor_text)
      "<li class=\"breadcrumb-item\"><a href=\"#{link}\">#{anchor_text}</a></li>"
    end

    def active_list_item(anchor_text)
      "<li class=\"breadcrumb-item active\">#{anchor_text}</li>"
    end
  end
end