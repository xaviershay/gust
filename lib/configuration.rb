class Configuration
  def initialize(env)
    @env = env
  end

  def repository_root
    {
      "development" => "/tmp/gust",
      "test"        => "/tmp/gust_test",
    }.fetch(@env)
  end
end
