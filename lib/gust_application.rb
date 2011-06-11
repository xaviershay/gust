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

    gust_regex = %r{/gusts/([0-9a-f]{32})$}
    gust_file_regex = %r{/gusts/([0-9a-f]{32})/(.+)$}

    response = if request.path_info == '/'
      Controllers::Gust.new(@config, request.params).new
    elsif request.path_info =~ gust_file_regex
      id       = request.path_info[gust_file_regex, 1]
      filename = request.path_info[gust_file_regex, 2]

      Controllers::Gust.new(@config, request.params).raw(id, filename)
    elsif request.path_info =~ gust_regex
      id = request.path_info[gust_regex, 1]

      if request.post? || request.put?
        Controllers::Gust.new(@config, request.params).put(id)
      else
        Controllers::Gust.new(@config, request.params).show(id)
      end
    else
       Rack::Response.new(["NOT FOUND"], 404)
    end
    response.finish
  end
end
