require 'isolate/now'

namespace :spec do
  [:unit, :integration, :acceptance].each do |type|
    desc "Run all #{type} specs"
    task type do
      Dir["spec/#{type}/**/*_spec.rb"].each do |x|
        require_relative x
      end
    end
  end
end

desc "Run a full build including quality checks"
task :build do
  exec('bin/build')
end
 
desc "Ensure that various code quality metrics are met"
task :quality do
  coverage_threshold = 100
  ratio_threshold    = (0.0..1.5) # Don't care for now
  failures           = []

  require 'simplecov'
  coverage = SimpleCov::ResultMerger.merged_result.covered_percent 
  if coverage < coverage_threshold
    failures << "  Coverage % too low:           #{coverage} < #{coverage_threshold}"
  end

  code_loc = `cat lib/*.rb          | grep -v "#" | wc -l`.to_f
  spec_loc = `cat spec/**/*_spec.rb | grep -v "#" | wc -l`.to_f
  ratio    = spec_loc / code_loc

  unless ratio_threshold.cover?(ratio)
    failures << "  code:spec ratio out of range: #{ratio.round(2)} not in #{ratio_threshold}"
  end

  unless failures.empty?
    puts
    puts "Code quality standards not met:"
    puts failures
    exit 1
  end
end

desc "Run benchmarks"
task :benchmark do
  require 'benchmark'

  time = Benchmark.realtime {
    `ruby -Ilib -risolate/now -rgust_application -e ''`
  }
  puts "Startup Time\t#{time}"
end

task default: :build
