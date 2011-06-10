require_relative './enforce_max_run_time'

class AcceptanceTest < MiniTest::Unit::TestCase
  include EnforceMaxRunTime

  def initialize(session, method)
    @session = session
    super(method)
  end

  attr_reader :session

  def max_run_time
    0.25
  end

  # Paths
  def home_page
    '/'
  end

  # Assertions
  def assert_has_content(session, content)
    assert session.has_content?(content),
      "Page did not have content \"#{content}\". Was\n\n#{session.body}"
  end

  def assert_has_no_content(session, content)
    assert session.has_no_content?(content),
      "Page had content \"#{content}\". Was\n\n#{session.body}"
  end
end
