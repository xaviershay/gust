require_relative '../unit_helper'

require 'views/new_gust'

class Views::NewGustTest < UnitTest
  def test_renders_with_no_errors
    html = Views::NewGust.new(
      errors: {}
    ).render

    assert_includes html, "Gust!"
  end
  def test_show_errors
    html = Views::NewGust.new(
      errors: {filename: [:blank]}
    ).render

    assert_includes html, "Filename must not be blank"
  end
end
