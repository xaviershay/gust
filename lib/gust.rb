require 'ostruct'
require 'grit'
require "gust_file"

class Gust < Struct.new(:directory)
  def id
    File.basename(directory)
  end

  def files
    repo.commits.first.tree.contents.map do |blob|
      GustFile.new(blob.name, blob.data)
    end
  end

  def update(files)
    Dir.chdir(directory) do
      files.each do |file|
        File.open(file[:filename], "w") do |f|
          f.write(file[:content])
        end
        repo.add(file[:filename])
      end
    end

    repo.commit_index('via web')
  end

  private

  def repo
    @repo ||= Grit::Repo.new(directory)
  end
end
