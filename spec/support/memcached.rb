RSpec.configure do |config|
  # empty memcache before every spec
  config.before(:each) do
    Class.new.extend(Utils::Memcached::Common).client.flush_all # clear memecached
  end
end


