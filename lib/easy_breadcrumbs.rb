require "easy_breadcrumbs/version"
require 'easy_breadcrumbs/breadcrumb'

module Sinatra
  module EasyBreadcrumbs
    def easy_breadcrumbs
      # get path from current Rack::Request object
      request_path = request.path

      # the rest is handled by Breadcrumb class
      Breadcrumb.new(request_path).html
    end
  end

  # Register helper with Sinatra::Application
  helpers EasyBreadcrumbs
end
