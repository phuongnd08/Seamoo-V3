class BotRunnerJob
  def perform
    started_at = Time.now
    begin
      Delayed::Worker.logger.warn "BotRunner Running"
      # Find all league that have only 1 waiting users sofar, and this waiting users is not a bot
      #   -> If find one, invoke 1 more bot for that league
      #       -> Register the bot to league
      League.all.each do |league|
        waiting_user_ids = league.waiting_user_ids
        Delayed::Worker.logger.warn "Watch [#{league.name}]: #{waiting_user_ids.inspect}"
        # bot user_id is negative one
        if (waiting_user_ids.size == 1 && waiting_user_ids.first > 0)
          bot = Bot.awake_new
          bot.data[:league_id] = league.id
        end
      end

      Bot.awaken.each do |bot|
        bot.run
      end
      # Run all awaking bots
      #   -> Any bots that said they finished their jobs should be retire to be used again
      
      # Sleep between beats
      sleep Matching.bot_sleep_time_between_beats unless started_at < Matching.bot_life_time.ago

    end while started_at > Matching.bot_life_time.ago 
  ensure
    Delayed::Worker.logger.warn "BotRunner Quitting. Queue another BotRunner"
    Delayed::Job.enqueue BotRunnerJob.new unless Delayed::Job.count > 1
  end
end
