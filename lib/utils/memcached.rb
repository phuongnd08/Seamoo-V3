module Utils
  class Memcached
    class << self
      def client
        @@client ||= Dalli::Client.new(MEMCACHED['server'], :namespace => MEMCACHED['namespace'])
      end
    end
  end
end
