require_relative 'acceptance_helper'

class AuthorSignupTest < AcceptanceTest
  def test_happy_path
    session.visit home_page
    assert_has_content session, 'Hello'
  end
end
