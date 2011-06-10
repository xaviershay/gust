module Views
  class NewGust
    def initialize(data)
      @data = data
      @data[:errors] ||= {}
      @data[:errors][:filename] ||= []
    end

    def render
      html = <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>Gust!</title>
          </head>
          <body>
            <h1>Gust!</h1>
            <form action='/gusts/#{@data[:id]}' method='post'>
      HTML

      if @data[:errors][:filename].include?(:blank)
        html += <<-HTML
              <p class='errors'>
                Filename must not be blank
              </p>
        HTML
      end

      html += <<-HTML
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

      html
    end
  end
end
