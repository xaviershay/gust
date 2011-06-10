require 'gust'

class GustRepository
  def initialize(repository_root)
    @repository_root = repository_root
  end

  def find(name)
    dir = File.join(@repository_root, name)
    Gust.new(dir)
  end

  def find_or_create(name)
    dir = File.join(@repository_root, name)
    unless File.directory?(dir)
      `mkdir #{dir}`
      Dir.chdir(dir) do
        `git init`
      end
    end

    Gust.new(dir)
  end

  def recent(n)
    Dir[File.join(@repository_root, "*")].sort_by {|gust_directory| 
      File.mtime(gust_directory) 
    }.reverse.first(n).map {|gust_directory| 
      Gust.new(gust_directory) 
    }
  end
end
