source 'http://rubygems.org'

gem 'rails', '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql'
gem 'haml', ">=3.1.alpha.147"
gem 'omniauth', '0.2.0.beta5'
gem 'authlogic'
gem "jquery-rails"
gem "dalli"
gem "delayed_job"
gem "settingslogic"
gem "gravtastic"
gem "sass"
gem "compass", ">=0.11.beta.3"
gem "compass-susy-plugin", ">=0.9.beta.3"
gem "compass-colors"
gem "fancy-buttons", ">=1.1.0.alpha.1"
gem "will_paginate", "~> 3.0.pre2"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger

# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rspec-rails', "~> 2.5"
  gem 'parallel_tests'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'spork'
  gem 'launchy'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'pickle'
  gem 'webmock', :require => false
end

group :development do
  gem "rails3-generators"
  gem 'haml-rails'
  gem "ruby-debug"
  gem "heroku"
  gem "hpricot", :require => false
end
