Redis.current = Redis.connect({}.merge(ServicesSettings.redis).symbolize_keys)
