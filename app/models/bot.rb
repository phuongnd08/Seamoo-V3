class Bot < User
  {
    :data => :type
  }.each do |field, identifier|
    self.instance_eval %{
      protected
      def #{field}
        @@mem_hash_for_#{field} ||= Utils::Memcached::MemHash.new({:category => Bot.name, :field => :#{field}}, :#{identifier})
      end
    }

    self.class_eval %{
      def #{field}
        @inst_mem_hash_for#{field} ||= Utils::Memcached::MemHash.new({:category => Bot.name, :id => self.id, :field => :#{field}}, :#{identifier})
      end
    }
  end

  class << self
    def rnd
      rand
    end

    def awaken
      awaken_ids = (data[:awaken_ids] || [])
      find(awaken_ids)
    end

    def awake_new
      new_bot_name = (Matching.bot_names - awaken.map(&:display_name)).first
      new_bot = find_or_create_by_display_name(
        :display_name => new_bot_name, 
        :email => new_bot_name + '@bot.com')
        data[:awaken_ids] = (data[:awaken_ids] || []) + [new_bot.id]
        new_bot.data[:match_id] = nil
        new_bot.data[:match_request_retried] = 0
        new_bot
    end

    def kill(bot)
      data[:awaken_ids] = (data[:awaken_ids] || []) - [bot.id]
    end
  end

  def run
    # try to answer un-answered question at a predefined speed
    unless data[:match_id].nil?
      match = Match.find_by_id(data[:match_id])
      unless match.nil? || match.finished?
        match_user = match.match_users.find_by_user_id(self.id)
        if match.started?
          number_of_questions_to_answer = (Time.now - match.started_at)/Matching.bot_time_per_question
          number_of_questions_to_answer = [match.questions.size, number_of_questions_to_answer].min
          (match_user.current_question_position...number_of_questions_to_answer).each do |index|
            answer = Bot.rnd > Matching.bot_correctness ? nil : correct_answer(match_user.current_question)
            match_user.add_answer(index, answer) 
          end
        end
        match_user.save
      else; die; end
    else
      unless data[:league_id].nil?
        unless data[:match_request_retried].nil? || data[:match_request_retried] >= Matching.bot_max_match_request_retries
          data[:match_id] = League.find(data[:league_id]).request_match(self.id, true).try(:id)
          data[:match_request_retried] += 1
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
