require_relative 'acceptance_helper'
require 'digest/md5'

class RecentGustsTest < AcceptanceTest
  def setup
    super
    @config = Configuration.new('test')
    FileUtils.rm_rf(@config.repository_root + '/*')
  end

  def test_can_see_recent_gusts
    repository = GustRepository.new(@config.repository_root)
    gusts = [
      repository.find_or_create(Digest::MD5.hexdigest('a')).tap {|x| x.update([filename: 'a.txt', content: 'hi there content']) },
      repository.find_or_create(Digest::MD5.hexdigest('b')).tap {|x| x.update([filename: 'b.txt', content: 'other']) }
    ]
    session.instance_eval do
      visit '/'
    end

    assert_has_content session, gusts[0].files[0].filename
    assert_has_content session, gusts[1].files[0].filename

    session.click_link "Gust"
    session.click_link gusts[0].files[0].filename

    assert_has_content session, gusts[0].files[0].content
  end

end
