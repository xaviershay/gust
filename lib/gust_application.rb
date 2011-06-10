require 'configuration'
require 'views/new_gust'
require 'views/show_gust'
require 'gust_repository'
require 'ostruct'

class GustApplication
  def initialize(opts = {})
    opts[:config] ||= Configuration.new(ENV['RACK_ENV'])
    @config = opts[:config]
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.path_info == '/'
      view = Views::NewGust.new
      response = Rack::Response.new(view.render)
      response.finish
    elsif request.path_info == '/gusts' && request.post?
      id = 'test123'

      repository = GustRepository.new(@config.repository_root)
      gust = repository.find_or_create(id)
      gust.update([
        filename: request.params["filename"].to_s.gsub(/[^a-z0-9_\-\.]/i, '-'),
        content:  request.params["content"]
      ])

      response = Rack::Response.new
      response.redirect("/gusts/#{id}")
      response.finish
    else
      id = 'test123'
      
      repository = GustRepository.new(@config.repository_root)
      gust = repository.find(id)

      view = Views::ShowGust.new(
        files: gust.files
      )
      response = Rack::Response.new(view.render)
      response.finish
    end
  end
end
