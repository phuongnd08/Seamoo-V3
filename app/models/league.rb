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
    :stuck_since,
    :left
  ]
  protected
  @@attrs.each do |attr|
    define_method attr do
      @nest ||= {}
      @nest[attr] ||= Nest.new("league:#{self.id}:#{attr}")
    end
  end

  public

  def match_for(user, force = false)
    assign_proper_ticket(user, force)
    create_or_find_match_for(user).tap do |match|
      unless match
        self.stuck_since[user.id].set Time.now.to_i
      else
        self.stuck_since[user.id].del
      end
    end
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

  public

  def stuck_for?(user)
    self.stuck_since[user.id].exists &&
      (Time.now - Time.at(self.stuck_since[user.id].get_i) > MatchingSettings.stuck_time.seconds)
  end

  def assign_next_ticket(user)
    self.ticket[user.id].set self.ticket_counter.incr
  end

  def assign_proper_ticket(user, force)
    if self.ticket[user.id].exists
      if force || stuck_for?(user)
        bad_mtid = match_temp_id(user)
        begin
          assign_next_ticket(user)
        end while (match_temp_id(user) == bad_mtid)
      end
    else
      assign_next_ticket(user)
    end
  end

  def first_user_in_match?(user)
    self.ticket[user.id].get_i % MatchingSettings.max_users_per_match == 1
  end

  def create_or_find_match_for(user)
    mtid = match_temp_id(user)
    if (self.match_id[mtid].get_i == 0) && first_user_in_match?(user)
      Match.create(:league => self).tap {|match| self.match_id[mtid].set match.id }
    else
      Match.find_by_id(self.match_id[mtid].get_i)
    end
  end

  def match_temp_id(user)
    (self.ticket[user.id].get_i - 1) / MatchingSettings.max_users_per_match + 1
  end

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
