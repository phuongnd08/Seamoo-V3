class League < ActiveRecord::Base
  include Utils::Waiter

  belongs_to :category
  has_many :matches
  has_many :memberships
  validates :status, :inclusion => { :in => ['active', 'coming_soon'] }
  scope :active, where(:status => 'active')

  private
  @@attrs = [
    :match_temp_id,
    :match_id,
    :ticket,
    :ticket_counter,
    :stuck_since
  ]
  @@attrs.each do |attr|
    self.class_eval %{
      protected
        def #{attr}
          @nest_for_#{attr} ||= Nest.new("league:" + self.id.to_s + ":#{attr}")
        end
    }
  end

  public

  def stuck_for?(user_id)
    self.stuck_since[user_id].exists && (Time.now - Time.at(self.stuck_since[user_id].get_i) > MatchingSettings.stuck_time.seconds)
  end

  def assign_ticket(user_id)
      self.ticket[user_id].set self.ticket_counter.incr
  end

  def match_temp_id(user_id)
    (self.ticket[user_id].get_i - 1) / MatchingSettings.max_users_per_match + 1
  end

  def match_for(user, force = false)
    if self.ticket[user.id].exists
      if force || stuck_for?(user.id)
        bad_mtid = match_temp_id(user.id)
        begin
          assign_ticket(user.id)
        end while (match_temp_id(user.id) == bad_mtid)
      end
    else
      assign_ticket(user.id)
    end

    mtid = match_temp_id(user.id)
    unless self.match_id[mtid].get_i > 0
      if self.ticket[user.id].get_i % MatchingSettings.max_users_per_match == 1
        self.match_id[mtid].set Match.create(:league => self).id
      end
    end

    match = Match.find_by_id(self.match_id[mtid].get_i)
    unless match
      self.stuck_since[user.id].set Time.now.to_i
    else
      self.stuck_since[user.id].del
    end
    match
  end

  def available?
    self.status == 'active'
  end

  def previous
    League.where(:category_id => self.category_id, :level => self.level - 1)
  end

  def advanced?
    self.level > 0
  end

  def dom_name
    name.downcase.split(/\s+/).join("_")
  end

  def initialize(*args)
    super
  end


  def ticket_provided?(user_id)
    user_match_ticket[user_id].present? &&
      user_lastseen[user_id].get.to_i &&
      user_lastseen[user_id].get.to_i > MatchingSettings.requester_stale_after.seconds.ago.to_i
  end

  public

  def random_questions(count)
    league_questions = category.questions.where(:level => self.level)
    league_questions_count = league_questions.count
    raise "Number of required questions(#{count}) is more than questions in league(#{league_questions_count})" if count > league_questions_count
    used = {}
    result = []
    count.times do
      number = Utils::RndGenerator.next(league_questions_count, used)
      used[number] = true
      result << league_questions.offset(number).limit(1).first
    end
    result
  end
end
