require_relative 'unit_helper'

require 'router'

class RouterTest < UnitTest

  def test_process_invalid_path
    router = Router.new(nil, {})
    request = MiniTest::Mock.new
    request.expect(:path_info, '/', [])
    response = router.process(request)
    assert_equal 404, response.status
  end

  def test_process_similar_but_not_whole_path
    router = Router.new(nil, {
      '/test' => {}
    })
    request = MiniTest::Mock.new
    request.expect(:path_info, '/bogus/test/bogus', [])
    response = router.process(request)
    assert_equal 404, response.status
  end

  def test_process_invalid_method
    router = Router.new(nil, {
      '/' => {}
    })
    request = MiniTest::Mock.new
    request.expect(:path_info, '/', [])
    request.expect(:request_method, 'GET', [])
    response = router.process(request)
    assert_equal 406, response.status
  end

end
