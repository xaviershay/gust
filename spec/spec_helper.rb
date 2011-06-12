require 'isolate'
ENV['ISOLATE_ENV'] = ENV['RACK_ENV'] = 'test'
Isolate.now!

if ENV["COVERAGE"]
  require 'simplecov'
  unless ENV["RESET_COVERAGE"] == '0'
    FileUtils.rm_f SimpleCov.coverage_path + '/resultset.yml'
  end
  SimpleCov.start do
    add_filter '/tmp/'
    add_filter '/spec/'
  end
  SimpleCov.at_exit do
    SimpleCov.result
  end

end

$LOAD_PATH.unshift(File.expand_path("../support", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

require 'minitest/unit'
require 'minitest/autorun'
