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
        <section id='upload'>
      HTML

      @data[:files].each do |file|
        buffer += <<-HTML
          <h2>#{escape_html(file.filename)}
          <a href='/gusts/#{@data[:gust_id]}/#{escape_html(file.filename)}'>Raw</a>
          </h2>
          <div><pre class="#{brush_class(file)}">#{escape_html(file.content)}</pre></div>
        HTML
      end

      buffer += '</section>'
      buffer
    end

    def has_brush?(extension)
      %w{ rb patch diff js css }.include? extension
    end

    def brush_class(file)
      has_brush?(file.extension) && "brush: #{file.extension}"
    end

  end
end
