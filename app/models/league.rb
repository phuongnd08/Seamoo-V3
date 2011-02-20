class League < ActiveRecord::Base
  belongs_to :category
  has_many :matches

  def add_user_to_match(match_id, user_id)
    if match_id.present? && Match.find(match_id).finished?
      false # user cannot be added to finished match
    else
      MatchUser.create(:match_id => match_id, :user_id => user_id) unless (match_id.nil? || MatchUser.find_by_match_id_and_user_id(match_id, user_id))
      true
    end
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

    @@status = "[u] #{user_id}: [ut] #{user_ticket[user_id]} [t] #{match_ticket}, [p] #{match_position}, [mid] #{match_id[match_ticket]}"
    # puts @@status
    match_id[match_ticket] != nil ? Match.find(match_id[match_ticket]) : nil
  end

  protected
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
    match_user_id[{:match_ticket => match_ticket, :position => match_position}] == user_id \
    && match_id[match_ticket]!=nil \
    && !Match.find(match_id[match_ticket]).finished? \
    && MatchUser.find_by_match_id_and_user_id(match_id[match_ticket], user_id).present?
  end
end
