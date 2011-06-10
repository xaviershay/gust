require 'rack/utils'

module Views
  module MainLayout
    include Rack::Utils

    def render
      <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>Gust!</title>
          </head>
          <body>
            <h1>Gust!</h1>
            #{content}
          </body>
        </html>
      HTML
    end
  end
end
