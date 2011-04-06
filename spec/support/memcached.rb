RSpec.configure do |config|
  # empty memcache before every spec
  config.before(:each) do
    Utils::Memcached::Common.client.flush_all if example.metadata[:memcached]# clear memecached
  end
end


