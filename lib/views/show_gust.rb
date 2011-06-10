require 'rack/utils'

module Views
  class ShowGust
    include Rack::Utils

    def initialize(data)
      @data = data
    end

    def render
      gust = @data[:gust]

      body = <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>Gust!</title>
          </head>
          <body>
            <h1>Gust!</h1>
            <p><a href="/gusts/#{@data[:gust_id]}">Permalink</a></p>
      HTML

      @data[:files].each do |file|
        body += <<-HTML
          <h2>#{escape_html(file.filename)}</h2>
          <div><pre>#{escape_html(file.content)}</pre></div>
        HTML
      end

      body += <<-HTML
          </body>
        </html>
      HTML

      body
    end
  end
end
