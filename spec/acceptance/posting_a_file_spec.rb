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

  def test_with_validation_errors
    session.instance_eval do
      visit '/'
      fill_in 'Filename', with: ''
      fill_in 'File',     with: ''
      click_button 'Gust!'
    end

    assert_has_content session, "Filename must not be blank"
  end

  def assert_has_file_with_content(session, filename, content)
    assert_has_content session, filename
    assert_has_content session, content
  end
end
