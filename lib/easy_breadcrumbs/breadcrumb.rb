require 'active_support/inflector/methods'

class Breadcrumb
  include ActiveSupport::Inflector
  
  # request_path argument is value returned by Rack::Request#path
  def initialize(request_path)
    @request_path = request_path.scan(/\/[^\/]+/)
  end

  def to_html
    list_items = format_list_items(@request_path)
    <<~HTML.chomp
      <ol class=\"breadcrumb\">
      <li class=\"breadcrumb-item\"><a href=\"/\">Home</a></li>
      #{list_items}
      </ol>
    HTML
  end

  private

  def format_list_items(path)
    list_items = []
    current_path = ""

    path.each_with_index do |directory, index|
      current_path << directory
      
      if directory =~ /\d/
        text_for_anchor = format_anchor_text(path[index - 1])
        anchor_text = singularize(text_for_anchor)
      else
        anchor_text = format_anchor_text(directory)
      end

      if directory == path.last
        list_items << active_list_item(anchor_text)
      else
        list_items << link_list_item(current_path, anchor_text)
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