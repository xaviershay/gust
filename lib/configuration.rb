class Configuration
  def initialize(env)
    @env = env
  end

  def repository_root
    {
      "development" => "/var/gust",
      "test"        => "/tmp/gust_test",
      "production"  => "/var/gust"
    }.fetch(@env)
  end
end
