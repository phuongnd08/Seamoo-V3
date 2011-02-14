namespace :match do
  desc "Reset matching status"
  task :reset => :environment do
    Object.new.extend(Utils::Memcached::Common).client.flush_all
  end
end
