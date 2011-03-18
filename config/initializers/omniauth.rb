require 'omniauth/openid'
require 'openid/store/memcache'

# you will be able to access the above providers by the following url
# /auth/providername for example /auth/twitter /auth/facebook
#
Rails.application.config.middleware.use OmniAuth::Strategies::OpenID, 
  OpenID::Store::Memcache.new(Dalli::Client.new(MemcachedSettings.server, :namespace => MemcachedSettings.namespace)),
  :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"
  #use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "yahoo",   :identifier => "https://me.yahoo.com"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, OauthSettings.facebook.app_id, OauthSettings.facebook.app_secret
  # provider :twitter,  'KEY', 'SECRET'
  # provider :linked_in, 'KEY', 'SECRET'
  provider :open_id, OpenID::Store::Memcache.new(Dalli::Client.new(MemcachedSettings.server, :namespace => MemcachedSettings.namespace))
end

require 'openid/store/nonce'
require 'openid/store/interface'
module OpenID
  module Store
    class Memcache < Interface
      def use_nonce(server_url, timestamp, salt)
        return false if (timestamp - Time.now.to_i).abs > Nonce.skew
        ts = timestamp.to_s # base 10 seconds since epoch
        nonce_key = key_prefix + 'N' + server_url + '|' + ts + '|' + salt
        result = @cache_client.add(nonce_key, '', expiry(Nonce.skew + 5))

        return result #== true (edited 10/25/10)
      end
    end
  end
end

# you won't be able to access the openid urls like /auth/google
# you will be able to access them through
# /auth/open_id?openid_url=https://www.google.com/accounts/o8/id
# /auth/open_id?openid_url=https://me.yahoo.com
