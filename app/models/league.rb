class League < ActiveRecord::Base
  include Utils::Waiter

  belongs_to :category
  has_many :matches
  has_many :memberships
  validates :status, :inclusion => { :in => ['active', 'coming_soon'] }
  scope :active, where(:status => 'active')

  private
  @@attrs = [
    :user_match_ticket,
    :user_lastseen,
    :user_league_ticket,
    :match_id,
    :match_user_id,
    :waiting_user,
    :active_user
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

  def add_user_to_match(match_id, user_id)
    if match_id.present? && Match.find(match_id).finished?
      false # user cannot be added to finished match
    else
      MatchUser.create(:match_id => match_id, :user_id => user_id) unless (match_id.nil? || MatchUser.find_by_match_id_and_user_id(match_id, user_id))
      true
    end
  end



  def initialize(*args)
    super
  end


  def ticket_provided?(user_id)
    user_match_ticket[user_id].present? &&
      user_lastseen[user_id].get.to_i &&
      user_lastseen[user_id].get.to_i > MatchingSettings.requester_stale_after.seconds.ago.to_i
  end

  def add_waiting_user(user_id, is_bot)
    slot = waiting_user[:counter].incr % MatchingSettings.waiting_slots_size
    waiting_user[slot].hset :id, user_id
    waiting_user[slot].hset :bot, is_bot
    waiting_user[slot].hset :time, Time.now.to_i
  end

  def request_match(user_id, is_bot = false)
    user_match_ticket[user_id].set user_match_ticket[:counter].incr unless ticket_provided?(user_id)
    user_league_ticket[user_id] = user_league_ticket[:counter].incr if user_league_ticket[user_id].nil?
    user_lastseen[user_id].set Time.now.to_i
    add_waiting_user(user_id, is_bot)
    ok = false
    while !ok do
      match_ticket = (user_match_ticket[user_id].get.to_i - 1) / MatchingSettings.users_per_match + 1
      match_position = ((user_match_ticket[user_id].get.to_i - 1) % MatchingSettings.users_per_match) + 1
      unless user_finished?(match_ticket, user_id)
        # when user leave match through official request, do not add him to the same match
        unless user_joined_before?(match_ticket, user_id, match_position)
          match_user_id[match_ticket][match_position].set user_id
          if participating?(match_ticket, match_position, user_id)
            ok = true
          elsif can_participate?(match_ticket, match_position)
            case match_position
            when 2
              # second user create the match
              match = Match.create(:league => self)
              MatchUser.create(:match_id => match.id, :user_id => user_id)
              match_id[match_ticket].set match.id
              ok = true
            else
              # other user just register to match
              ok = add_user_to_match(match_id[match_ticket].get, user_id)
            end
          end
        end
      end
      user_match_ticket[user_id].set user_match_ticket[:counter].incr unless ok
    end

    @@status = "[u] #{user_id}: [ut] #{user_match_ticket[user_id]} [t] #{match_ticket}, [p] #{match_position}, [mid] #{match_id[match_ticket]}"
    # puts @@status
    Match.find(match_id[match_ticket].get) if match_id[match_ticket].get
  end

  def waiting_users_info
    min_time = MatchingSettings.requester_stale_after.seconds.ago.to_i
    wusers = (0..MatchingSettings.waiting_slots_size-1).
      map{|index| waiting_user[index]}.
      select{|user| (user.hlen > 0) && user.hget(:time).to_i > min_time}.
      group_by{|user| user.hget :id}.
      values.map{|group| group.sort_by{|user| user.hget :time}.last}
  end

  def leave_current_match(user_id)
    user_match_ticket[user_id].set nil
    user_lastseen[user_id].set nil
  end

  private
  def user_finished?(match_ticket, user_id)
    match_id[match_ticket].get && \
      MatchUser.find_by_match_id_and_user_id(match_id[match_ticket], user_id).try(:finished?)
  end

  def user_joined_before?(match_ticket, user_id, match_position)
    (1..match_position-1).map{|pos|
      match_user_id[match_ticket][pos].get.to_i
    }.include?(user_id)
  end

  def first_requester_available?(match_ticket)
    first_requester_id = try_until_not_nil_or_timeout(MatchingSettings.requester_stale_after) do
      match_user_id[match_ticket][1].get.to_i
    end
    if first_requester_id
      first_requester_lastseen = try_until_not_nil_or_timeout(MatchingSettings.requester_stale_after) do
        user_lastseen[first_requester_id].get.to_i
      end
      (first_requester_lastseen != nil) && (first_requester_lastseen >= MatchingSettings.requester_stale_after.seconds.ago.to_i)
    else
      false
    end
  end

  def match_started?(match_ticket)
    match_id[match_ticket].get && Match.find(match_id[match_ticket].get).started?
  end

  def can_participate?(match_ticket, match_position)
    if match_position == 1
      true
    else
      first_requester_available?(match_ticket) && ! match_started?(match_ticket)
    end
  end

  def user_playing?(match_ticket, user_id)
    match_user = MatchUser.find_by_match_id_and_user_id(match_id[match_ticket].get, user_id)
    match_user.present? && !match_user.finished? if match_user
  end

  def participating?(match_ticket, match_position, user_id)
    match_user_id[match_ticket][match_position].get == user_id && \
      match_id[match_ticket].get && \
      !Match.find(match_id[match_ticket].get).finished? && \
      user_playing?(match_ticket, user_id)
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
