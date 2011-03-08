class OAuthSettings < Settingslogic
  source "#{Rails.root}/config/oauth.yml"
  namespace Rails.env
end
