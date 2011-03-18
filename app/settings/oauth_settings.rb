class OauthSettings < Settingslogic
  source "#{Rails.root}/config/oauth.yml"
  namespace Rails.env
end
