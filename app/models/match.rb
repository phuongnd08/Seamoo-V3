class Match < ActiveRecord::Base
  has_many :match_users
  has_many :users, :through => :match_users
  has_many :match_questions
  has_many :questions, :through => :match_questions
  belongs_to :league

  def started?
    Time.now >= started_at
  end

  def finished?
    Time.now >= finished_at
  end

  def finished_at
    started_at + Matching.finished_after.seconds
  end

  def started_at
    created_at + Matching.started_after.seconds
  end
end
