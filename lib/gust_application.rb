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

    gust_regex = %r{/gusts/([0-9a-f]{32})$}
    gust_file_regex = %r{/gusts/([0-9a-f]{32})/(.+)$}
    repository = GustRepository.new(@config.repository_root)

    if request.path_info == '/'
      view = Views::NewGust.new(
        id: Digest::MD5.hexdigest([Time.now, rand].join),
        recent: repository.recent(10)
      )
      response = Rack::Response.new(view.render)
      response.finish
    elsif request.path_info =~ gust_file_regex
      id = request.path_info[gust_file_regex, 1]
      filename = request.path_info[gust_file_regex, 2]
      gust = repository.find(id)

      file = gust.files.detect {|x| x.filename == filename }

      response = Rack::Response.new(file.content)
      response.headers['Content-Type'] = 'text/plain'
      response.finish
    elsif request.path_info =~ gust_regex
      id = request.path_info[gust_regex, 1]
      errors = {}

      if request.post? || request.put?
        filename = request.params["filename"].to_s.gsub(/[^a-z0-9_\-\.]/i, '-')

        if filename.length == 0
          errors[:filename] ||= []
          errors[:filename] << :blank
        end

        if errors.empty?
          gust = repository.find_or_create(id)
          gust.update([
            filename: filename,
            content:  request.params["content"]
          ])
        end
      else
        gust = repository.find(id)
      end

      if gust
        view = Views::ShowGust.new(
          files:   gust.files,
          gust_id: id
        )
      else
        view = Views::NewGust.new(
          id:     id,
          errors: errors
        )
      end
      response = Rack::Response.new(view.render)
      response.finish
    else
      response = Rack::Response.new(["NOT FOUND"], 404)
      response.finish
    end
  end
end
