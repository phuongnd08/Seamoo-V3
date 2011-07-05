SeamooV3::Application.configure do
  config.after_initialize do
    Resque.redis = ServicesSettings.redis
  end
end
