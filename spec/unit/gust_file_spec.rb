require_relative 'unit_helper'

require 'gust_file'

class GustTest < UnitTest

  def test_file_extension
    assert_equal GustFile.new("test.name.rb").extension, "rb"
  end

  def test_file_without_extension
    assert_nil GustFile.new("README").extension
  end

end
