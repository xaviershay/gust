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

    gust_regex      = %r{^/gusts/([0-9a-f]{32})$}
    gust_file_regex = %r{^/gusts/([0-9a-f]{32})/(.+)$}
    home_regex      = %r{^/$}

    response = if request.path_info == '/' && request.get?
      Controllers::Gust.new(@config, request.params).new
    elsif request.path_info =~ gust_file_regex
      matches = request.path_info.match(gust_file_regex).captures
      Controllers::Gust.new(@config, request.params).raw(*matches)
    elsif request.path_info =~ gust_regex && (request.post? || request.put?)
      matches = request.path_info.match(gust_regex).captures
      Controllers::Gust.new(@config, request.params).put(*matches)
    elsif request.path_info =~ gust_regex && request.get?
      matches = request.path_info.match(gust_regex).captures
      Controllers::Gust.new(@config, request.params).show(*matches)
    else
       Rack::Response.new(["NOT FOUND"], 404)
    end
    response.finish
  end
end
