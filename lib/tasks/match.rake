namespace :match do
  desc "Reset matching status"
  task :reset => :environment do
    Utils::Memcached::Common.client.flush_all
  end

  desc "Queue a job so that bot can be awaken"
  task :start_bot => :environment do
    Delayed::Job.enqueue BotRunnerJob.new
  end
end
