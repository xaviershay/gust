require 'views/main_layout'

module Views
  class NewGust
    include Views::MainLayout

    def initialize(data)
      @data = data
      @data[:recent] ||= []
      @data[:errors] ||= {}
      @data[:errors][:filename] ||= []
    end

    def content
      html = <<-HTML
        <section id='upload'>
          <h2>Make One</h2>
        <form action='/gusts/#{@data[:id]}' method='post'>
      HTML

      if @data[:errors][:filename].include?(:blank)
        html += <<-HTML
          <p class='errors'>
            Filename must not be blank
          </p>
        HTML
      end

      recent_gusts = @data[:recent].map do |gust|
        "<li><a href='/gusts/#{gust.id}'>#{gust.files[0].filename}</a></li>"
      end.join("\n")

      html += <<-HTML
        <ol>
        <li>
          <label for='filename'>
            Filename
          </label>
          <input id='filename' name='filename' type='text' />
        </li>

        <li>
          <label for='content'>
            File
          </label>
          <textarea id='content' name='content'></textarea>
        </li>
        </ol>

        <input type='submit' value='Gust!' />
      </form>
      </section>
      <section>
        <h2>Recent</h2>
        <ol>
          #{recent_gusts}
        </ol>
      </section>
      HTML

      html
    end
  end
end
