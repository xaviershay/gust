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
        # TODO
      end
    else
       Rack::Response.new(["NOT FOUND"], 404)
    end
  end

  private

  attr_reader :config, :routes
end
