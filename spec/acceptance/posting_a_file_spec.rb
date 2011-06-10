require_relative 'acceptance_helper'

class PostingAFileTest < AcceptanceTest
  def test_happy_path
    session.instance_eval do
      visit '/'
      fill_in 'Filename', with: 'fixing.diff'
      fill_in 'File',     with: '> hello'
      click_button 'Gust!'
    end

    assert_has_file_with_content session, 'fixing.diff', '> hello'

    session.instance_eval do
      click_link "Permalink"
    end

    assert_has_file_with_content session, 'fixing.diff', '> hello'
  end

  def assert_has_file_with_content(session, filename, content)
    assert_has_content session, filename
    assert_has_content session, content
  end
end
