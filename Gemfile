source 'http://rubygems.org'

gem 'rails', '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql'
gem 'haml'
gem 'omniauth'
gem 'authlogic'
gem "jquery-rails", :git =>  "https://github.com/indirect/jquery-rails.git"
gem "dalli"
gem "delayed_job"

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
  gem 'rspec', ">= 2.0.0.beta.22"
  gem 'rspec-rails', ">= 2.0.0.beta.22"
end

group :test do
  gem 'test-unit', '1.2.3'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'cucumber'
  gem 'cucumber-rails', :git => 'git://github.com/aslakhellesoy/cucumber-rails.git'
  gem 'spork'
  gem 'launchy'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'parallel'
  gem 'pickle'
  gem 'webmock', :git => 'git://github.com/phuong-nguyen/webmock.git'
end

group :development do
  gem "rails3-generators"
  gem 'haml-rails'
  gem "ruby-debug"
  gem "heroku"
  gem "hpricot", :require => false
end
