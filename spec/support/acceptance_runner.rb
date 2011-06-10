require 'parallel'

class AcceptanceRunner < MiniTest::Unit
  def initialize(opts = {})
    super()

    @opts = opts
  end

  def _run_suite(suite, type)
    our_session = session
    
    begin
      wrapped_suite = Class.new(suite) do
        define_method(:initialize) do |method_name|
          super(our_session, method_name)
        end

        def self.to_s
          @name
        end

        def self.name=(value)
          @name = value
        end
      end
      wrapped_suite.name = suite.to_s

      super(wrapped_suite, type)
    ensure
    end
  end

  def _run_suites_in_parallel(suites, type)
    
    # Parallel acceptance tests are disabled for now since webkit really doesn't like it
    result = Parallel.map(suites, :in_processes => 1 || Parallel.processor_count) do |suite|
      install_coverage_hook!

      ret = _run_suite(suite, type)
      {
        :failures         => failures,
        :errors           => errors,
        :report           => report,
        :run_suite_return => ret
      }
    end
    self.failures = result.inject(0)  {|sum, x| sum + x[:failures] }
    self.errors   = result.inject(0)  {|sum, x| sum + x[:errors] }
    self.report   = result.inject([]) {|sum, x| sum + x[:report] }
    result.map {|x| x[:run_suite_return] }
  end


  alias_method :_run_suites_in_series, :_run_suites
  alias_method :_run_suites, :_run_suites_in_parallel

  def session
    @session ||= Capybara::Session.new(:webkit, Gust.new).tap(&:driver)
  end

  def coverage?
    @opts[:coverage]
  end

  def install_coverage_hook!
    if !@hooked && coverage?
      @hooked = true

      def file_lock(filename)
        File.open(filename, "w") do |f|
          f.flock(File::LOCK_EX)
          yield
        end
      end

      SimpleCov.at_exit do
        result = SimpleCov::Result.new(Coverage.result)
        result.command_name += Process.pid.to_s
        file_lock(SimpleCov.coverage_path + '/coverage-lock') do
          SimpleCov::ResultMerger.store_result(result)
        end
      end
    end
  end
end

