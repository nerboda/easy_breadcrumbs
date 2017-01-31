require 'sinatra/base'
require 'easy_breadcrumbs/version'
require 'easy_breadcrumbs/breadcrumb'

module Sinatra
  include ::EasyBreadcrumbs

  module EasyBreadcrumbs
    Breadcrumb = ::EasyBreadcrumbs::Breadcrumb

    def easy_breadcrumbs
      breadcrumb = Breadcrumb.new(config)
      breadcrumb.to_html
    end

    private

    EXCLUDED_VARS = [:@default_layout,
                     :@preferred_extension,
                     :@app,
                     :@template_cache,
                     :@template_cache,
                     :@env,
                     :@request,
                     :@response,
                     :@params].freeze

    def config
      # The name of the current Sinatra Application
      app = self.class

      # The Rack::Request object
      request_path = request.path

      # All defined GET request routes
      route_matchers = app.routes['GET'].map { |route| route[0] }

      { request_path: request_path,
        route_matchers: route_matchers,
        view_variables: view_variables }
    end

    def view_variables
      instance_variables
        .select { |var| !excluded_var?(var) }
        .map { |var| fetch_ivar(var) }
    end

    def fetch_ivar(var)
      name = var.to_s.delete('@').to_sym
      value = instance_eval(var.to_s)

      { name: name, value: value }
    end

    def excluded_var?(var)
      EXCLUDED_VARS.include?(var)
    end
  end

  # Register helper with Sinatra::Application
  helpers EasyBreadcrumbs
end
