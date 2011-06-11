require 'views/new_gust'
require 'views/show_gust'

module Controllers
  class Gust
    def initialize(config, params)
      @config = config
      @params = params
    end

    def new
      view = Views::NewGust.new(
        id: Digest::MD5.hexdigest([Time.now, rand].join),
        recent: repository.recent(10)
      )
      response = Rack::Response.new(view.render)
    end

    def show(id)
      gust = repository.find(id)
      view = Views::ShowGust.new(
        files:   gust.files,
        gust_id: id
      )
      response = Rack::Response.new(view.render)
    end

    def put(id)
      errors = {}
      filename = params["filename"].to_s.gsub(/[^a-z0-9_\-\.]/i, '-')

      if filename.length == 0
        errors[:filename] ||= []
        errors[:filename] << :blank
      end

      if errors.empty?
        gust = repository.find_or_create(id)
        gust.update([
          filename: filename,
          content:  params["content"]
        ])
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
    end

    private

    attr_reader :params 

    def repository
      @repository ||= GustRepository.new(@config.repository_root)
    end
  end
end
