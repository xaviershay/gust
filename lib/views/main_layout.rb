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
            <link href="http://hax/styles.css" media="screen" rel="stylesheet" type="text/css" />
            <style>
              label {
                display: block;
                font-weight: bold;
              }

              input[type=text] {
                width: 100%;
                font-family: monospace;
              }
              textarea {
                width: 100%;
                height: 300px;
                font-family: monospace;
              }
            </style>
          </head>
          <body>
            <header>
              <h1>Gust!</h1>
            </header>
            <article>
            #{content}
            </article>
          </body>
        </html>
      HTML
    end
  end
end
