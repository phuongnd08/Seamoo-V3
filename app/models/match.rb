class Match < ActiveRecord::Base
  has_many :match_users
  has_many :users, :through => :match_users
  has_many :match_questions
  has_many :questions, :through => :match_questions

  def started?
    Time.now - 15.seconds >= created_at
  end

  def finished?
    Time.now - 60.seconds >= created_at
  end
end
