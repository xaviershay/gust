require 'views/main_layout'

module Views
  class NewGust
    include Views::MainLayout

    def initialize(data)
      @data = data
      @data[:errors] ||= {}
      @data[:errors][:filename] ||= []
    end

    def content
      html = <<-HTML
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
      HTML

      html
    end
  end
end
