Delayed::Worker.logger = ActiveSupport::BufferedLogger.new("log/#{Rails.env}_delayed_jobs.log", Rails.logger.level)
Delayed::Worker.logger.auto_flushing = 1
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 0
Delayed::Worker.max_run_time = 5.minutes
