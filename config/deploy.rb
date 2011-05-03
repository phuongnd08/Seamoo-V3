require "bundler/capistrano"
require "delayed/recipes"
set :application, "main_app"
set :repository,  "git@github.com:phuongnd08/Seamoo-V3.git"
set :rails_env, :production

set :scm, :git
set :branch, :master
set :user, "ubuntu"
set :use_sudo, false
ssh_options[:keys] = ["#{Dir.pwd}/dautri.pem"]
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{user}/#{application}"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, "chat.dautri.net"                          # Your HTTP server, Apache/etc
role :db, "chat.dautri.net", :primary => true                          # Your HTTP server, Apache/etc
role :web, "chat.dautri.net"                          # Your HTTP server, Apache/etc

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
#

desc "Print current status on server"
task :echo, :role => :app do
  puts "pwd"
  run "pwd"
  puts "ruby -v"
  run "ruby -v"
  puts "freem -mt"
  run "free -mt"
  puts "try_sudo"
  puts try_sudo
end

namespace :symlink do
  desc "Symlink database.yml from database.linux.yml"
  task :db_settings, :role => :app do
    run "cd #{current_path}/config && ln -s database.linux.yml database.yml"
  end
end

before "deploy:migrate", "symlink:db_settings"

set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && sudo #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "sudo kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "sudo kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "sudo kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

namespace :bots do
  desc "Start bots by queue delayed jobs in db"
  task :awake, :roles => :app do
    run "export RAILS_ENV=#{rails_env} && cd #{current_path} && bundle exec rake match:reset && bundle exec rake match:start_bot"
  end
end

namespace :symlink do
  desc "Symlink database.yml"
  task :database do
    run "cd #{current_path}/config && ln -fs database.linux.yml database.yml"
  end
end

after "deploy:symlink", "symlink:database"
# Delayed Job  

after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"
after "deploy:start", "bots:awake"
