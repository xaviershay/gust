require_relative 'integration_helper'
require 'tmpdir'

require 'gust_repository'

class GustRepositoryTest < IntegrationTest
  def setup
    super
    @temp_dir = Dir.mktmpdir
  end

  def test_create_and_update_new_repository_that_does_not_exist

    repository = GustRepository.new(@temp_dir)

    gust = repository.find_or_create("new_repo")

    dir = "#{@temp_dir}/new_repo"

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
  end

  def test_recent_repositories
    repository = GustRepository.new(@temp_dir)

    gusts = [
      repository.find_or_create("a"),
      repository.find_or_create("b"),
      repository.find_or_create("c")
    ]

    assert_equal [
      gusts[2],
      gusts[1]
    ], repository.recent(2)
  end

  def teardown
    FileUtils.remove_entry_secure @temp_dir if @temp_dir
    super
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
