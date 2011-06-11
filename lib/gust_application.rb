require 'configuration'
require 'router'
require 'controllers/gust'

require 'digest/sha1'
require 'ostruct'

class GustApplication
  def initialize(opts = {})
    opts[:config] ||= Configuration.new(ENV['RACK_ENV'])
    @config = opts[:config]
  end

  def call(env)
    router.process(Rack::Request.new(env)).finish
  end

  def router
    @router ||= Router.new(@config,
      %r{^/$} => {
        'GET' => [Controllers::Gust, :new]
      },
      %r{^/gusts/([0-9a-f]{32})$} => {
        'GET'  => [Controllers::Gust, :show],
        'POST' => [Controllers::Gust, :put]
      },
      %r{^/gusts/([0-9a-f]{32})/(.+)$} => {
        'GET' => [Controllers::Gust, :raw]
      }
    )
  end
end
