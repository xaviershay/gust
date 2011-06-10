require_relative './enforce_max_run_time'

class IntegrationTest < MiniTest::Unit::TestCase
  include EnforceMaxRunTime

  def max_run_time
    0.1
  end
end
