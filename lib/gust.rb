require 'ostruct'

class Gust < Struct.new(:directory)
  def id
    File.basename(directory)
  end

  def files
    Dir.chdir(directory) do
      Dir["*"].map do |file|
        OpenStruct.new(
          filename: file,
          content:  File.read(file)
        )
      end
    end
  end

  def update(files)
    Dir.chdir(directory) do
      files.each do |file|
        File.open(file[:filename], "w") do |f|
          f.write(file[:content])
        end
      end
      `git add --all`
      `git commit -m 'via web'`
    end
  end
end
