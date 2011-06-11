require 'rack/response'

class Router
  def initialize(config, routes)
    @config = config
    @routes = routes
  end

  # Returns a `Rack::Response`
  def process(request)
    route = routes.detect {|regex, _|
      request.path_info.match(regex)
    }

    response = if route
      action = route[1][request.request_method]
      if action
        controller = action[0].new(config, request.params)
        controller.send(action[1], *request.path_info.match(route[0]).captures)
      else
        respond(406, "NOT ACCEPTABLE")
      end
    else
      respond(404, "NOT FOUND")
    end
  end

  private

  attr_reader :config, :routes

  def respond(code, description)
    Rack::Response.new([description], code).tap do |response|
      response.headers['Content-Type'] = 'text/plain'
    end
  end
end
