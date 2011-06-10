require_relative 'acceptance_helper'

class ErrorsTest < AcceptanceTest
  def test_bogus_page
    session.visit "/bogus"

    assert_has_content session, "NOT FOUND"
  end
end
