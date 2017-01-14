require "easy_breadcrumbs/version"
require_relative "easy_breadcrumbs/breadcrumb"

module Sinatra
  module EasyBreadcrumbs
    def easy_breadcrumbs
      # Path from current Rack::Request object
      request_path = request.path

      # All GET request routes
      routes = Sinatra::Application.routes["GET"].map { |route| route[0] }
      
      # the rest is handled by Breadcrumb class
      breadcrumb = Breadcrumb.new(request_path, routes)
      breadcrumb.to_html
    end
  end

  # Register helper with Sinatra::Application
  helpers EasyBreadcrumbs
end
