require 'features/support/test_env'
Capybara.javascript_driver = :selenium
Capybara.default_wait_time = 5
Capybara.server_port = 5000 + TestEnv.number
