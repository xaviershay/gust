require_relative '../spec_helper'

require 'capybara'

require 'acceptance_runner'
require 'acceptance_test'

require 'gust'

MiniTest::Unit.runner = AcceptanceRunner.new(coverage: ENV['COVERAGE'])
