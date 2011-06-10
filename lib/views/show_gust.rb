require 'views/main_layout'

module Views
  class ShowGust
    include Views::MainLayout

    def initialize(data)
      @data = data
    end

    def content
      buffer = <<-HTML
        <p><a href="/gusts/#{@data[:gust_id]}">Permalink</a></p>
      HTML

      @data[:files].each do |file|
        buffer += <<-HTML
          <h2>#{escape_html(file.filename)}</h2>
          <div><pre>#{escape_html(file.content)}</pre></div>
        HTML
      end

      buffer
    end
  end
end
