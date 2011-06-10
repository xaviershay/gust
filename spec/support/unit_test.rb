require 'ostruct'
require_relative './enforce_max_run_time'

class UnitTest < MiniTest::Unit::TestCase
  include EnforceMaxRunTime

  def max_run_time
    0.001
  end

  def stub(args = {})
    OpenStruct.new(args)
  end
end
