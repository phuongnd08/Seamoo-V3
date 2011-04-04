class League < ActiveRecord::Base
  belongs_to :category
  has_many :matches
  has_many :memberships
  validates :status, :inclusion => { :in => ['active', 'coming_soon'] }

  def available?
    self.status == 'active'
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


  {
    :user_match_ticket_counter => :counter, 
    :user_match_ticket => :user_id, 
    :user_lastseen => :user_id, 
    :user_league_ticket_counter => :counter,
    :user_league_ticket => :user_id,
    :match_id => :match_ticket, 
    :match_user_id => :match_ticket,
    :waiting_counter => :counter, 
    :waiting_user => :position,
    :active_user => :position,
    :fake_user_counter => :counter,
    :fake_user => :position
  }.each do |field, identifier|
    self.class_eval %{
      protected
      def #{field}
        @mem_hash_for_#{field} ||= Utils::Memcached::MemHash.new({:category => League.name, :id => self.id, :field => :#{field}}, :#{identifier})
      end
    }
  end

  include Utils::Waiter

  def request_match(user_id, bot_request = false)
    user_match_ticket[user_id] = user_match_ticket_counter.incr if (user_match_ticket[user_id].nil?)
    user_league_ticket[user_id] = user_league_ticket_counter.incr if (user_league_ticket[user_id].nil?)
    user_lastseen[user_id] = Time.now.to_i
    waiting_user[waiting_counter.incr % Matching.waiting_slots_size] = { :id => user_id, :bot => bot_request, :time => Time.now.to_i }
    active_user[user_league_ticket[user_id] % Matching.active_slots_size] = { :id => user_id, :time => Time.now.to_i }
    ok = false
    while !ok do
      match_ticket = (user_match_ticket[user_id] - 1) / Matching.users_per_match + 1
      match_position = ((user_match_ticket[user_id] - 1) % Matching.users_per_match) + 1
      unless user_finished?(match_ticket, user_id)
        # when user leave match through official request, do not add him to the same match
        unless user_joined_before?(match_ticket, user_id, match_position)
          match_user_id[{:match_ticket => match_ticket, :position => match_position}] = user_id
          if participating?(match_ticket, match_position, user_id)
            ok = true
          elsif can_participate?(match_ticket, match_position)
            case match_position
            when 2
              # second user create the match
              match = Match.create(:league => self)
              MatchUser.create(:match_id => match.id, :user_id => user_id)
              match_id[match_ticket] = match.id
              ok = true
            else 
              # other user just register to match 
              ok = add_user_to_match(match_id[match_ticket], user_id)
            end
          end
        end
      end
      user_match_ticket[user_id] = user_match_ticket_counter.incr unless ok
    end

    @@status = "[u] #{user_id}: [ut] #{user_match_ticket[user_id]} [t] #{match_ticket}, [p] #{match_position}, [mid] #{match_id[match_ticket]}"
    # puts @@status
    match_id[match_ticket] != nil ? Match.find(match_id[match_ticket]) : nil
  end

  def waiting_users
    min_time = Matching.requester_stale_after.seconds.ago.to_i
    wusers = (0..Matching.waiting_slots_size-1).
              map{|index| waiting_user[index]}.
              select{|user| user!=nil && user[:time] > min_time}.
              group_by{|user| user[:id]}.
              values.map{|group| group.sort_by{|user| user[:time]}.last}
  end

  def active_users
    min_time = Matching.user_inactive_after.seconds.ago.to_i
    ausers = (0..Matching.active_slots_size-1).
              map{|index| active_user[index]}.
              select{|user| user!=nil && user[:time] > min_time}.
              group_by{|user| user[:id]}.
              values.map{|group| group.sort_by{|user| user[:time]}.last}
  end

  def fake_active_users
    position = fake_user_counter.incr
    fake_user[position % Matching.fake_active_users_slot] = Matching.bots_arr[Utils::RndGenerator.rnd(Matching.bots_arr.size)].first
    (0...Matching.fake_active_users_slot).map{|index| fake_user[index]}.
      select{|bot_name| bot_name.present?}.
      to_set.
      map{|name| Bot.new(:name => name)}
  end

  def leave_current_match(user_id)
    user_match_ticket[user_id] = nil
    user_lastseen[user_id] = nil
  end

  protected
  def user_finished?(match_ticket, user_id)
    if match_id[match_ticket].present?
      match_user = MatchUser.find_by_match_id_and_user_id(match_id[match_ticket], user_id)
      match_user.present? && match_user.finished?
    else
      false
    end
  end

  def user_joined_before?(match_ticket, user_id, match_position)
    (1..(match_position - 1)).map{|pos| match_user_id[{:match_ticket => match_ticket, :position => pos}]}.include?(user_id) 
  end

  def can_participate?(match_ticket, match_position)
    if match_position == 1
      true
    else
      # user can only participate if first requester is still around && match not started
      first_requester_id = try_until_not_nil_or_timeout(Matching.requester_stale_after) { match_user_id[{:match_ticket => match_ticket, :position => 1}] }
      can = if first_requester_id
              first_requester_lastseen= try_until_not_nil_or_timeout(Matching.requester_stale_after) { user_lastseen[first_requester_id] }
              first_requester_lastseen =! nil && first_requester_lastseen > Matching.requester_stale_after.seconds.ago.to_i
            else
              false
            end
      can && (match_id[match_ticket].nil? || !Match.find(match_id[match_ticket]).started?)
    end
  end

  def participating?(match_ticket, match_position, user_id)
    b = match_user_id[{:match_ticket => match_ticket, :position => match_position}] == user_id
    b = b && match_id[match_ticket]!=nil 
    b = b && !Match.find(match_id[match_ticket]).finished?
    if (b)
      match_user = MatchUser.find_by_match_id_and_user_id(match_id[match_ticket], user_id)
      b = b && match_user.present? && !match_user.finished?
    end
    b
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
