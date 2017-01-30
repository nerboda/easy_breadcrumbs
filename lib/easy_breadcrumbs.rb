require 'sinatra/base'
require 'easy_breadcrumbs/version'
require 'easy_breadcrumbs/breadcrumb'

module Sinatra
  include ::EasyBreadcrumbs

  module EasyBreadcrumbs
    Breadcrumb = ::EasyBreadcrumbs::Breadcrumb

    def easy_breadcrumbs
      # Path from current Rack::Request object
      request_path = request.path

      # All GET request routes
      route_matchers = self.class.routes['GET'].map { |route| route[0] }

      # If there's a :home setting for the settings object, use that value
      # Otherwise it defaults to true
      if settings.respond_to?(:home)
        
      else

      end

      # The rest is handled by Breadcrumb class
      breadcrumb = Breadcrumb.new(request_path, route_matchers)
      breadcrumb.to_html
    end
  end

  # Register helper with Sinatra::Application
  helpers EasyBreadcrumbs
end
