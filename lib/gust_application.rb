require 'configuration'
require 'controllers/gust'

require 'digest/sha1'
require 'ostruct'

class GustApplication
  def initialize(opts = {})
    opts[:config] ||= Configuration.new(ENV['RACK_ENV'])
    @config = opts[:config]
  end

  def call(env)
    request = Rack::Request.new(env)
    gust_controller = Controllers::Gust.new(@config, request.params)

    routes = {
      %r{^/$} => {
        'GET' => [gust_controller, :new]
      },
      %r{^/gusts/([0-9a-f]{32})$} => {
        'GET'  => [gust_controller, :show],
        'POST' => [gust_controller, :put]
      },
      %r{^/gusts/([0-9a-f]{32})/(.+)$} => {
        'GET' => [gust_controller, :raw]
      }
    }

    route = routes.detect {|regex, _|
      request.path_info.match(regex)
    }

    response = if route
      action = route[1][request.request_method]
      if action
        action[0].send(action[1], *request.path_info.match(route[0]).captures)
      else
        # TODO
      end
    else
       Rack::Response.new(["NOT FOUND"], 404)
    end
    response.finish
  end
end
