module Views
  class NewGust
    def initialize(data)
      @data = data
    end

    def render
      <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>Gust!</title>
          </head>
          <body>
            <h1>Gust!</h1>
            <form action='/gusts/#{@data[:id]}' method='post'>
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
