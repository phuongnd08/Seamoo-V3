module Utils
  module Memcached
    module Common
      def client
        @@client ||= Dalli::Client.new(MEMCACHED['server'], :namespace => MEMCACHED['namespace'])
      end

      def hash_to_key(hash)
        h = hash.stringify_keys
        h.keys.sort.map{|key| [key, h[key]].join("@")}.join("_")
      end
    end

    class Hash
      include Memcached::Common
      def initialize(base_key_hash)
        @base_key_hash = base_key_hash
      end

      def [](identifier_hash)
        client.get(hash_to_key(@base_key_hash.merge(identifier_hash)))
      end
      def []=(identifier_hash, value)
        client.set(hash_to_key(@base_key_hash.merge(identifier_hash)), value)
      end

      def incr(identifier_hash, delta=1, default=1)
        client.incr(hash_to_key(@base_key_hash.merge(identifier_hash)), delta, 0, default) 
      end
    end
  end
end
