class BotRunnerJob
  def perform
    started_at = Time.now
    begin
      puts("Bot Running")
      # Find all league that have only 1 waiting users sofar, and this waiting users is not a bot
      #   -> If find one, invoke 1 more bot for that league
      #       -> Register the bot to league
      League.all.each do |league|
        waiting_user_ids = league.waiting_user_ids
        # bot user_id is negative one
        if (waiting_user_ids.size == 1 && waiting_user_ids.first > 0)
          bot = Bot.awake_new
          bot.data[:match_id] = league.request_match(bot.id, true).try(:id)
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
    Delayed::Job.enqueue BotRunnerJob.new unless Delayed::Job.count > 1
  end
end
