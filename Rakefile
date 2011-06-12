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
 
task :coverage_report do
  require 'isolate/now'
  require 'simplecov'

  SimpleCov.result.format!
end
desc "Ensure that various code quality metrics are met"
task :quality do
  coverage_threshold = 100
  ratio_threshold    = (0.0..1.5) # Don't care for now
  failures           = []
  metrics            = []

  # NFI why this doesn't work on 1.9.2
  if RUBY_VERSION >= '1.9.3'
    require 'isolate/now'
    require 'simplecov'
    coverage = SimpleCov::ResultMerger.merged_result.covered_percent 
    metrics << "Coverage\t%i%" % coverage
    if coverage < coverage_threshold
      failures << "  Coverage % too low:           #{coverage} < #{coverage_threshold}"
    end
  end

  code_loc = `cat lib/*.rb          | grep -v "#" | wc -l`.to_f
  spec_loc = `cat spec/**/*_spec.rb | grep -v "#" | wc -l`.to_f
  ratio    = spec_loc / code_loc
  metrics << "Code:Spec ratio\t%.2f" % ratio

  unless ratio_threshold.cover?(ratio)
    failures << "  Code:Spec ratio out of range: #{ratio.round(2)} not in #{ratio_threshold}"
  end

  puts metrics.join("\n")

  unless failures.empty?
    puts
    puts "Code quality standards not met:"
    puts failures
    exit 1
  end
end

desc "Run nonfunctional checks. Requires `rake benchmark` to have been run."
task :nonfunctional do
  startup_time = 0.5

  results = File.read("out/benchmarks.tsv").lines.map {|x| x.split(/\t+/) }
  time = results.detect {|x| x[0] == 'Startup Time' }[1].to_f
  failures = []

  if time > startup_time
    failures << "  Startup time too high: #{time} > #{startup_time}"
  end
  unless failures.empty?
    puts
    puts "Non-functional requirements not met:"
    puts failures
    exit 1
  end
end

desc "Run benchmarks"
task :benchmark do
  require 'benchmark'
  require 'fileutils'

  time = Benchmark.realtime {
    `ruby -Ilib -risolate/now -rgust_application -e ''`
  }
  output = "Startup Time\t#{time}"
  FileUtils.mkdir_p("out")
  File.open("out/benchmarks.tsv", "w") {|f| f.puts output }
  puts output
end

task default: :build
