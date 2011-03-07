Before('@omniauth') do
  OmniAuth.config.test_mode = true

  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  
end

After('@omniauth') do
  OmniAuth.config.test_mode = false
end

