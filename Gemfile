source 'http://rubygems.org'

gem 'rails', '3.0.0'
gem 'rake', '0.8.7'

gem 'escape_utils' # dealing with this warning 'regex match against utf-8 string'
gem 'mysql2', "~> 0.2.7"
gem 'haml', ">=3.1.alpha.147"
gem 'omniauth', '0.2.0.beta5'
gem 'authlogic'
gem "jquery-rails"
gem "delayed_job"
gem "settingslogic"
gem "gravtastic"
gem "sass"
gem "compass", ">=0.11.beta.3"
gem "compass-susy-plugin", ">=0.9.beta.3"
gem "compass-colors"
gem "fancy-buttons", ">=1.1.0.alpha.1"
gem "will_paginate", "~> 3.0.pre2"
gem "hoptoad_notifier"
gem "redis"
gem "nest"
gem "resque"

gem 'aws-s3', :require => 'aws/s3'

gem 'eventmachine'
gem 'faye'

group :development, :test do
  gem 'rspec-rails', "~> 2.5"
  gem 'rio', "~> 0.4.3.1", :git => 'https://github.com/wishdev/rio.git'
  gem "ruby-debug19", :require => 'ruby-debug', :platforms => 'ruby_19'
  gem 'ruby-debug', :platforms => 'rbx'
  gem 'spork'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git', :branch => 'async_is_my_bitch'
  gem 'parallel'
  gem 'pickle'
end

group :development do
  gem "rails3-generators"
  gem 'haml-rails'
  gem "hpricot", :require => false
  gem "capistrano", :require => false
  gem 'rmagick', :require => false
end
