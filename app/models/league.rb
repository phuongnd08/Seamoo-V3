class League < ActiveRecord::Base
  include Utils
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

  def request_match(user_id)
    debugger
    user_ticket = mem_hash[{:field => 'ticket', :user_id => user_id}]
    if (user_ticket.nil?)
      user_ticket = mem_hash.incr({:field => 'user_counter'})
    end
    ok = false
    while !ok do
      match_ticket = (user_ticket - 1) / 4 + 1
      match_position = user_ticket % 4
      case match_position
      when 2
        # second user create the match
        match = Match.create(:league => self)
        MatchUser.create(:match_id => match.id, :user_id => user_id)
        mem_hash[{:field => 'match_id', :ticket => match_ticket}] = match.id
        ok = true
      else 
        # other user just register to match 
        ok = add_user_to_match(mem_hash[{:field => 'match_id', :ticket => match_ticket}], user_id)
      end
      user_ticket = mem_hash.incr({:field => 'user_counter'}) unless ok
    end
    mem_hash[{:field => 'ticket', :user_id => user_id}] = user_ticket
  end

  protected
  def mem_hash
    @mem_hash ||= Memcached::Hash.new(:category => League.class.name, :id => self.id)
  end
end
