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
            <link href="/syntaxhighlighter/shCore.css" media="screen" rel="stylesheet" type="text/css" />
            <link href="/syntaxhighlighter/shThemeDefault.css" media="screen" rel="stylesheet" type="text/css" />
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
            <script type="text/javascript" src="/syntaxhighlighter/xregexp-min.js"></script>
            <script type="text/javascript" src="/syntaxhighlighter/shCore.js"></script>
            <script type="text/javascript" src="/syntaxhighlighter/shAutoloader.js"></script>
            <script type="text/javascript">
            SyntaxHighlighter.autoloader(
              "rb         /syntaxhighlighter/shBrushRuby.js",
              "patch diff /syntaxhighlighter/shBrushDiff.js",
              "js         /syntaxhighlighter/shBrushJScript.js",
              "css        /syntaxhighlighter/shBrushCss.js"
            );
            SyntaxHighlighter.all();
            </script>
          </body>
        </html>
      HTML
    end
  end
end
