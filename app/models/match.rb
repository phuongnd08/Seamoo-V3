class Match < ActiveRecord::Base
  has_many :match_users
  has_many :users, :through => :match_users
  has_many :match_questions
  has_many :questions, :through => :match_questions
  belongs_to :league

  before_create :fetch_question

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

  def fetch_question
    league.category.questions[0...Matching.questions_per_match].each { |q| questions << q }
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
end
