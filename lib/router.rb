require 'rack/response'

class Router
  METHODS    = 1
  CONTROLLER = 0
  METHOD     = 1

  def initialize(config, routes)
    @config = config
    @routes = compile(routes)
  end

  # Returns a `Rack::Response`
  def process(request)
    route, params = match_route(request.path_info)

    if route
      action = route[METHODS][request.request_method]
      if action
        controller = action[CONTROLLER].new(config, request.params)
        controller.send(action[METHOD], *params)
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

  def match_route(path)
    params = nil
    [routes.detect {|regex, _|
      params = path.match(regex)
    }, params ? params.captures : nil]
  end

  def compile(routes)
    Hash[routes.map {|path, mappings|
      [Regexp.new("^%s$" % path), mappings]
    }]
  end
end
