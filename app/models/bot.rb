class Bot < User
  include Gravtastic

  gravtastic :default => DisplaySettings.default_gravatar

  cattr_accessor :awaken_ids

  @@awaken_ids = Nest.new(:awaken_ids)

  protected
  @@attrs = [:match_id, :match_request_retried, :league_id]
  @@attrs.each do |attr|
    self.class_eval %{
      def #{attr}
        @nest_for_#{attr} ||= Nest.new("bot:" + self.id.to_s + ":#{attr}")
      end
    }
  end

  public

  attr_accessor :name

  def initialize(*attr)
    super
    unless self.name.blank?
      self.display_name = Bot.names[:all][self.name] unless self.display_name.present?
      self.email = [self.name, '@', SiteSettings.bot_domain].join("") unless self.email.present?
    end
  end

  class << self
    def names
      unless @names
        @names = {}
        File.open(File.join(Rails.root, "config", "bots.txt"), "r:utf-8").each do |line|
          line.squish!
          if line =~ /^(\**)(.+)$/
            level = $1.length
            line = $2
            @names[level] ||= {}
            if (line =~ /^(\w+)\s(.+)$/)
              @names[level][$1] = {:display_name => $2, :level => level}
            else
              @names[level][line] = {:display_name => line, :level => level}
            end
          end
        end

        @names[:all] = names.inject({}) do |hash, (level, level_names)|
          hash = hash.merge(level_names)
          hash
        end
      end
      @names
    end

    def awaken
      find(@@awaken_ids.smembers)
    end

    def awake_new(level)
      available_bot_names = (names[level].keys - awaken.map(&:display_name))
      new_bot_name = available_bot_names[Utils::RndGenerator.next(available_bot_names.size)]
      new_bot = find_or_create_by_display_name(
        :display_name => names[level][new_bot_name][:display_name],
        :email => new_bot_name + "@#{SiteSettings.bot_domain}")
        @@awaken_ids.sadd(new_bot.id)
        new_bot.match_id.del
        new_bot.match_request_retried.set 0
        new_bot
    end

    def kill(bot)
      @@awaken_ids.srem bot.id
    end

    def listen
      Services::PubSub.client.subscribe("/bots") do |message|
        debugger
        match = Match.find_by_id(message.match_id)
        if match
          process = lambda do
            bot = awake_new(match.league.level)
            bot.perform(match)
          end

          #EM.defer process
          process.call
        end
      end
    end
  end

  def perform(match)
    match.subscribe(self)
    match_user = match.match_user_for(self)
    Kernel.sleep(match.seconds_until_start)
    match.questions.count.times do |index|
      Kernel.sleep Kernel.rand(MatchingSettings.bot_time_per_question * 2)
      if match.seconds_until_end > 0
        answer = Utils::RndGenerator.rnd > MatchingSettings.bot_correctness ? nil : correct_answer(match_user.current_question)
        match_user.add_answer(index, answer)
      else
        break
      end
    end
    die
  end

  def die
    Bot.kill(self)
  end

  def correct_answer(question)
    case question.data
    when MultipleChoice
      question.data.options.find_index{ |o| o.correct }.to_s
    when FollowPattern
      question.data.answer
    end
  end
end
