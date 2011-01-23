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
      def initialize(base_key_hash, default_key = :auto_field)
        @base_key_hash = base_key_hash
        @default_key = default_key
      end

      def [](key)
        identifier_hash = {@default_key => identifier_hash} unless identifier_hash.is_a?(Hash)
        client.get(serialized_key(key))
      end
      def []=(key, value)
        client.set(serialized_key(key), value)
      end

      def incr(key=:counter, delta=1, default=1)
        client.incr(serialized_key(key), delta, 0, default) 
      end

      def base_key_hash
        @base_key_hash
      end

      protected
      def serialized_key(hash_key)
        hash_key= {@default_key => hash_key} unless hash_key.is_a?(Hash)
        hash_to_key(@base_key_hash.merge(hash_key))
      end
    end
  end
end
