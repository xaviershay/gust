require 'rack/utils'

module Views
  module MainLayout
    include Rack::Utils

    def render
      <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>Gust</title>
            <link href="/css/base.css"  media="screen" rel="stylesheet" type="text/css" />
            <link href="/css/extra.css" media="screen" rel="stylesheet" type="text/css" />
          </head>
          <body>
            <header>
              <section>
              <a href='/'><h1>Gust</h1></a>
              </section>
              <section></section>
              <section>
                <h3>
                <ul>
                  <li>Made by <a href='http://twitter.com/xshay'>@xshay</a></li>
                </ul>
                </h3>
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
