module Sinatra
  module EasyBreadcrumbs
    Breadcrumbs = ::EasyBreadcrumbs::Breadcrumbs

    def easy_breadcrumbs
      Breadcrumbs.new(config).to_html
    end

    private

    EXCLUDED_VARS = [:@default_layout, :@preferred_extension,
                     :@app, :@template_cache, :@template_cache,
                     :@env, :@request, :@response, :@params]

    Configuration = Struct.new(:request_path, :route_matchers, :view_variables)

    def config
      # The name of the current Sinatra Application
      app = self.class

      # The Rack::Request object
      request_path = request.path

      # All defined GET request routes
      route_matchers = app.routes['GET'].map { |route| route[0] }

      Configuration.new(request_path, route_matchers, view_variables)
    end

    # All user defined instance variables for current request.
    def view_variables
      instance_variables
        .select { |var| additional_var?(var) }
        .map { |var| fetch_ivar_value(var) }
    end

    def fetch_ivar_value(var)
      name = var.to_s.delete('@').to_sym
      value = instance_eval(var.to_s)

      { name: name, value: value }
    end

    def additional_var?(var)
      !EXCLUDED_VARS.include?(var)
    end
  end

  # Register helper with Sinatra::Application
  helpers EasyBreadcrumbs
end