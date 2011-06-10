require 'configuration'
require 'views/new_gust'
require 'views/show_gust'
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

    gust_regex = %r{/gusts/([0-9a-f]{32})}

    if request.path_info == '/'
      view = Views::NewGust.new(
        id: Digest::MD5.hexdigest([Time.now, rand].join)
      )
      response = Rack::Response.new(view.render)
      response.finish
    elsif request.path_info =~ gust_regex
      id = request.path_info[gust_regex, 1]
      repository = GustRepository.new(@config.repository_root)

      if request.post? || request.put?
        gust = repository.find_or_create(id)
        gust.update([
          filename: request.params["filename"].to_s.gsub(/[^a-z0-9_\-\.]/i, '-'),
          content:  request.params["content"]
        ])

        response = Rack::Response.new
        response.redirect("/gusts/#{id}")
        response.finish
      else
        gust = repository.find(id)
      end

      view = Views::ShowGust.new(
        files:   gust.files,
        gust_id: id
      )
      response = Rack::Response.new(view.render)
      response.finish
    else
      # TODO
    end
  end
end
