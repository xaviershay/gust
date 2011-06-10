module Views
  class NewGust
    def render
      <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>Gust!</title>
          </head>
          <body>
            <h1>Gust!</h1>
            <form action='/gusts' method='post'>
              <p>
                <label for='filename'>
                  Filename
                </label>
                <input id='filename' name='filename' />
              </p>

              <p>
                <label for='content'>
                  File
                </label>
                <textarea id='content' name='content'>
                </textarea>
              </p>

              <input type='submit' value='Gust!' />
            </form>
          </body>
        </html>
      HTML
    end
  end
end
