RSpec.configure do |config|
  # empty memcache before every spec
  config.before(:each) do
    Redis.current.flushdb if example.metadata[:caching]# clear memecached
  end
end
