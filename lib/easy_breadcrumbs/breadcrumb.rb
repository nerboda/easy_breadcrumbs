require 'active_support/inflector/methods'

class Breadcrumb
  include ActiveSupport::Inflector
  
  # request_path argument is value returned by Rack::Request#path
  def initialize(request_path, routes)
    @routes = routes
    @paths = to_paths(request_path)
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
    list_items = []

    paths.each_with_index do |path, index|
      full_path = path[:full_path]
      directory = path[:directory]

      if is_defined?(path, @routes)
        if directory =~ /\d/
          previous_path = paths[index - 1][:directory]
          text_for_anchor = format_anchor_text(previous_path)
          anchor_text = singularize(text_for_anchor)
        else
          anchor_text = format_anchor_text(directory)
        end

        if directory == paths.last[:directory]
          list_items << active_list_item(anchor_text)
        else
          list_items << link_list_item(full_path, anchor_text)
        end
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

  # Methods for parsing the path and figuring out which routes are defined
  def to_paths(request_path)
    directories = request_path.scan(/\/[^\/]+/)
    
    directories.map.with_index do |dir, index|
      full_path = directories[0..index].join
      
      { full_path: full_path, directory: dir }
    end
  end

  def is_defined?(path, routes)
    routes.any? { |route| path[:full_path].match(route) }
  end
end