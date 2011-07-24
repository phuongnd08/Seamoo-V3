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
  end

  def run
    # try to answer un-answered question at a predefined speed
    unless match_id.get_i == 0
      match = Match.find_by_id(match_id.get.to_i)
      unless match.nil?
        match_user = match.match_users.find_by_user_id(self.id)
        unless match_user.finished? || match.finished?
          if match.started?
            number_of_questions_to_answer = (Time.now - match.started_at)/MatchingSettings.bot_time_per_question
            number_of_questions_to_answer = [match.questions.size, number_of_questions_to_answer.floor].min
            (match_user.current_question_position...number_of_questions_to_answer).each do |index|
              answer = Utils::RndGenerator.rnd > MatchingSettings.bot_correctness ? nil : correct_answer(match_user.current_question)
              match_user.add_answer(index, answer)
            end
          end
        else; match_user.record!; die; end
      else; die; end
    else
      unless league_id.get.nil?
        unless match_request_retried.get.nil? || match_request_retried.get.to_i >= MatchingSettings.bot_max_match_request_retries
          id = League.find(league_id.get.to_i).request_match(self.id, true).try(:id)
          match_id.set id if id
          match_request_retried.incr
        else; die; end
      else; die; end
    end
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
