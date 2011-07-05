require 'omniauth/openid'
require 'openid/store/filesystem'

# you will be able to access the above providers by the following url
# /auth/providername for example /auth/twitter /auth/facebook
#
Rails.application.config.middleware.use OmniAuth::Strategies::OpenID, 
  OpenID::Store::Filesystem.new(File.join(Rails.root, '/tmp')),
  :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"
  #use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "yahoo",   :identifier => "https://me.yahoo.com"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, OauthSettings.facebook.app_id, OauthSettings.facebook.app_secret, :scope => OauthSettings.facebook.scope
  # provider :twitter,  'KEY', 'SECRET'
  # provider :linked_in, 'KEY', 'SECRET'
  provider :open_id,  OpenID::Store::Filesystem.new(File.join(Rails.root, '/tmp'))
end

# you won't be able to access the openid urls like /auth/google
# you will be able to access them through
# /auth/open_id?openid_url=https://www.google.com/accounts/o8/id
# /auth/open_id?openid_url=https://me.yahoo.com
