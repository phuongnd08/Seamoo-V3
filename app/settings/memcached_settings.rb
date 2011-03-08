class MemcachedSettings < Settingslogic
  source "#{Rails.root}/config/memcached.yml"
  namespace Rails.env
end
