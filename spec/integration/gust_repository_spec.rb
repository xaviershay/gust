require_relative 'integration_helper'
require 'tmpdir'

require 'gust_repository'

class GustRepositoryTest < IntegrationTest
  def test_create_and_update_new_repository_that_does_not_exist
    temp_dir = Dir.mktmpdir

    repository = GustRepository.new(temp_dir)

    gust = repository.find_or_create("new_repo")

    dir = "#{temp_dir}/new_repo"

    assert_git_repository dir
    assert_equal [], Dir["#{dir}/*"]

    gust.update([{
      filename: 'test.txt',
      content:  'HELLO'
    }])

    filename = File.join(dir, 'test.txt')
    assert File.file?(filename), "test.txt not created"
    assert_equal "HELLO", File.read(filename)
    assert_commit_count dir, 1

    reloaded = repository.find("new_repo")
    assert_equal gust, reloaded

    gust = reloaded

    assert_equal 1, gust.files.length, "Number of files"
    assert_equal 'test.txt', gust.files[0].filename
    assert_equal 'HELLO',    gust.files[0].content
  ensure
    FileUtils.remove_entry_secure temp_dir if temp_dir
  end

  def assert_git_repository(path)
    assert File.directory?(path + "/.git"), "Not a git repo: #{path}"
  end

  def assert_commit_count(dir, expected)
    assert_equal expected,
      Dir.chdir(dir) { `git log --format=oneline`.lines.to_a.length }, 
      "Expected number of git commits not found"
  end
end
