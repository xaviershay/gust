require_relative '../spec_helper'

require 'integration_test'
require 'integration_runner'

MiniTest::Unit.runner = IntegrationRunner.new(coverage: ENV['COVERAGE'])
