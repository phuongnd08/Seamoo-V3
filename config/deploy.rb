require 'bundler/capistrano'
set :application, "main_app"
set :repository,  "git@github.com:phuongnd08/Seamoo-V3.git"

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
end

namespace :symlink do
  desc "Symlink database.yml from database.linux.yml"
  task :db_settings, :role => :app do
    run "cd #{current_path}/config && ln -s database.linux.yml database.yml"
  end
end

after "deploy:update_code", "symlink:db_settings"
