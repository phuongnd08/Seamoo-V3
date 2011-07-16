class Match < ActiveRecord::Base
  has_many :match_users
  has_many :users, :through => :match_users
  has_many :match_questions, :order => 'id ASC'
  has_many :questions, :through => :match_questions
  belongs_to :league
  validates :league, :presence => true

  private
  @@attrs = [
    :ticket,
    :counter
  ]
  @@attrs.each do |attr|
    self.class_eval %{
      protected
        def #{attr}
          @nest_for_#{attr} ||= Nest.new("match:" + self.id.to_s + ":#{attr}")
        end
    }
  end

  public
  def subscribe(user)
    unless ticket[user.id].exists
      unless started?
        if ticket[user.id].incr == 1
          match_users << MatchUser.new(:user => user)
          if counter.incr == MatchingSettings.min_users_per_match
            self.formed_at = Time.now
            fetch_questions # this in turn save the formed at attr
          end
        end
      end
    end

    ticket[user.id].exists
  end

  def formed?
    self.formed_at.present? && self.formed_at >= Time.now
  end

  def started_at
    if self.formed_at
      formed_at + MatchingSettings.started_after.seconds
    end
  end

  def seconds_until_start
    [0, (started_at - Time.now).round].max
  end

  def started?
    started_at.present? && Time.now >= started_at
  end

  def ended?
    Time.now >= ended_at
  end

  def ended_at
    started_at + MatchingSettings.duration.seconds
  end

  def finished?
    ended? || (finished_at.present? && Time.now >= finished_at)
  end

  def fetch_questions
    self.update_attribute(:questions, league.random_questions(MatchingSettings.questions_per_match)) if self.questions.empty?
  end

  def check_if_finished!
    users_finished_at = self.match_users.map(&:finished_at)
    self.finished_at = unless users_finished_at.include?(nil)
      users_finished_at.max
    else
      nil
    end

    self.save!
  end

  def ranked_match_users
    match_users.map{|mu| [mu, mu.score]}.sort_by{|mus| mus.last}.map{|mus| mus.first}.reverse
  end

  def match_user_for(user)
    self.match_users.find_by_user_id(user.id)
  end
end
