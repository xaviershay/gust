class GustFile < Struct.new(:filename, :content)

  def extension
    match = filename.match(/\.(\w+)$/)
    match && match[1]
  end

end
