class Match < ActiveRecord::Base
  has_many :match_users
  has_many :users, :through => :match_users
  has_many :match_questions, :order => 'id ASC'
  has_many :questions, :through => :match_questions
  belongs_to :league

  before_create :fetch_questions

  def seconds_until_started
    [0, (started_at - Time.now).round].max
  end

  def seconds_until_ended
    [0, (ended_at- Time.now).round].max
  end

  def started?
    Time.now >= started_at
  end

  def finished?
    ended? || (finished_at.present? && Time.now >= finished_at)
  end

  def ended?
    Time.now >= ended_at
  end

  def ended_at
    started_at + Matching.ended_after.seconds
  end

  def started_at
    created_at + Matching.started_after.seconds
  end

  def fetch_questions
    self.questions = league.random_questions(Matching.questions_per_match) if self.questions.empty?
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

  def match_user_for(user_id)
    self.match_users.find_by_user_id(user_id)
  end
end
