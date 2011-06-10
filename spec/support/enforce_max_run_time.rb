module EnforceMaxRunTime
  def setup
    super

    @start_time = Time.now
  end

  def teardown
    if @passed
      end_time = Time.now - @start_time
      assert(
        end_time < max_run_time,
        "Test exceeded max runtime: %.3fs > %.3fs" % [end_time, max_run_time]
      )
    end

    super
  end

  def max_run_time
    raise "Must be overriden by subclasses: decimal max number of seconds."
  end
end
