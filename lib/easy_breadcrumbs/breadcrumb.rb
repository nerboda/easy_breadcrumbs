module Sinatra
  module EasyBreadcrumbs
    class Breadcrumb
      # request_path argument is value returned by Rack::Request#path
      def initialize(request_path)
        @request_path = request_path
      end

      def html
        "<h1>#{@request_path}</h1>"
      end
    end
  end
end