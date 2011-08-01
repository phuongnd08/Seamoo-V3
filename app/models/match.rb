class Match < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :match_users
  has_many :users, :through => :match_users
  has_many :match_questions, :order => 'id ASC'
  has_many :questions, :through => :match_questions
  belongs_to :league
  validates :league, :presence => true

  private
  @@attrs = [
    :ticket,
    :counter,
    :left
  ]
  protected
  @@attrs.each do |attr|
    define_method attr do
      @nest ||= {}
      @nest[attr] ||= Nest.new("match:" + self.id.to_s + ":#{attr}")
    end
  end

  public
  def channel
    "/matches/#{self.id}"
  end

  def subscribe(user)
    unless self.finished? || left[user.id].get_b
      unless ticket[user.id].exists
        unless started?
          if ticket[user.id].incr == 1
            match_users << MatchUser.new(:user => user)

            Services::PubSub.publish(self.channel, {
              :type => :join,
              :user => user.brief
            })

            if counter.incr == MatchingSettings.min_users_per_match
              self.formed_at = Time.now
              fetch_questions! # this in turn save the formed at attr
              Services::PubSub.publish(self.channel, {
                :type => :status_changed,
                :info => brief
              })
            end
          end
        end
      end
      ticket[user.id].exists
    else
      false
    end
  end

  def unsubscribe(user)
    left[user.id].set true
  end

  def summary
    {
      :players => match_users.map{ |mu| mu.user.brief.merge :current_question_position => mu.current_question_position },
    }.merge brief
  end

  def status
    if finished?
      :finished
    elsif started?
      :started
    elsif formed?
      :formed
    else
      :waiting
    end
  end

  def brief
    case status
    when :formed
      {
        :seconds_until_start => seconds_until_start,
        :duration => MatchingSettings.duration
      }
    when :started
      { :seconds_until_end => seconds_until_end }
    when :finished
      { :result_url => match_path(self) }
    else
      {}
    end.merge(:status => status)
  end

  def formed?
    self.formed_at.present? && (Time.now >= self.formed_at)
  end

  def started_at
    if formed_at
      formed_at + MatchingSettings.started_after.seconds
    end
  end

  def seconds_until_start
    [0, (started_at - Time.now).round].max
  end

  def seconds_until_end
    [0, (ended_at - Time.now).round].max
  end

  def started?
    started_at.present? && Time.now >= started_at
  end

  def ended_at
    if started_at
      started_at + MatchingSettings.duration.seconds
    end
  end

  def ended?
    ended_at.present? && Time.now >= ended_at
  end

  def finished?
    ended? || (finished_at.present? && Time.now >= finished_at)
  end

  def fetch_questions!
    self.update_attribute(:questions, league.random_questions(MatchingSettings.questions_per_match)) if self.questions.empty?
  end

  def check_if_finished!
    unless match_users.any?{|mu| mu.finished_at.nil?}
      self.finished_at = Time.now
      Services::PubSub.publish(
        channel,
        :type => :status_changed,
        :info => brief
      )
      self.save!
    end
  end

  def ranked_match_users
    match_users.map{|mu| [mu, mu.score]}.sort_by{|mus| mus.last}.map{|mus| mus.first}.reverse
  end

  def match_user_for(user)
    self.match_users.find_by_user_id(user.id)
  end
end

