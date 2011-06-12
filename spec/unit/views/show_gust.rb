require_relative '../unit_helper'

require "gust_file"
require 'views/show_gust'

class Views::ShowGustTest < UnitTest
  def test_renders_with_no_errors
    names = %w{ test.rb test.js test.blarg test }
    html = Views::ShowGust.new(
      gust_id: 1,
      files: names.map { |name| GustFile.new(name) }
    ).render

    assert_includes html, "brush: rb"
    assert_includes html, "brush: js"
    assert !html.include?("brush: blarg")
  end
end
