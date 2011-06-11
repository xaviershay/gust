require 'configuration'
require 'controllers/gust'
require 'gust_repository'

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
    repository = GustRepository.new(@config.repository_root)

    response = if request.path_info == '/'
      Controllers::Gust.new(@config, request.params).new
    elsif request.path_info =~ gust_file_regex
      id = request.path_info[gust_file_regex, 1]
      filename = request.path_info[gust_file_regex, 2]
      gust = repository.find(id)

      file = gust.files.detect {|x| x.filename == filename }

      response = Rack::Response.new(file.content)
      response.headers['Content-Type'] = 'text/plain'
      response
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
