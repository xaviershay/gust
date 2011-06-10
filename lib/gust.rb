require 'configuration'

class Gust
  def initialize(opts = {})
    opts[:config] ||= Configuration.new(ENV['RACK_ENV'])
  end

  def call(env)
    response = Rack::Response.new("Hello")
    response.finish
  end
end
