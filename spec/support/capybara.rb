require File.expand_path('../test_env', __FILE__)
Capybara.javascript_driver = :selenium
Capybara.default_wait_time = 5
Capybara.server_port = 5000 + TestEnv.number
