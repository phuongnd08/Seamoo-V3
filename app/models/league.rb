class League < ActiveRecord::Base
  belongs_to :category
  has_many :matches

  def add_user_to_match(match_id, user_id)
    if (match_id != nil)
      match = Match.find(match_id)
      if (match.started?)
        return false # user cannot be added to finished match
      else
        MatchUser.create(:match_id => match.id, :user_id => user_id) unless MatchUser.find_by_match_id_and_user_id(match_id, user_id)
      end
    end
    true
  end


  {:user_ticket => :user_id, :user_lastseen => :user_id, :user_ticket_counter => :counter, 
    :match_id => :match_ticket, :match_user_id => :match_ticket}.each do |field, identifier|
    self.class_eval %{
      protected
      def #{field}
        @mem_hash_for_#{field} ||= Utils::Memcached::Hash.new({:category => League.class.name, :id => self.id, :field => :#{field}}, :#{identifier})
      end
    }
    end

  include Utils::Waiter

  def request_match(user_id)
    user_ticket[user_id] = user_ticket_counter.incr if (user_ticket[user_id].nil?)
    user_lastseen[user_id] = Time.now.to_i
    ok = false
    while !ok do
      match_ticket = (user_ticket[user_id] - 1) / 4 + 1
      match_position = user_ticket[user_id] % 4
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
      user_ticket[user_id] = user_ticket_counter.incr unless ok
    end
    match_id[match_ticket] != nil ? Match.find(match_id[match_ticket]) : nil
  end

  protected
  def can_participate?(match_ticket, match_position)
    unless match_position == 1
      # make sure first requester is still around  
      first_requester_id = match_user_id[{:match_ticket => match_ticket, :position => 1}]
      first_requester_lastseen= try_until_not_nil_or_timeout(5) do
        user_lastseen[first_requester_id]
      end

      unless first_requester_lastseen == nil 
        if first_requester_lastseen < Matching.requester_fresh.seconds.ago.to_i
          return false
        end
      else
        # first requester doesn't inform about himself.
        # some error during registering, perhaps memcached problem? or server restarted?
      end
    end
    true
  end

  def participating?(match_ticket, match_position, user_id)
    b = match_user_id[{:match_ticket => match_ticket, :position => match_position}] == user_id 
    b &&= match_id[match_ticket]!=nil
    b &&= !Match.find(match_id[match_ticket]).finished?
    b &&= MatchUser.find_by_match_id_and_user_id(match_id[match_ticket], user_id).present?
  end
end
