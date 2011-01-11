class League < ActiveRecord::Base
  belongs_to :category

  def request_match(options)
    match_request = MatchRequest.find_by_league_id_and_user_id(id, options[:user].id)
    if (match_request)
      if (match_request.match)
        if match_request.match.finished?
          match_request.update_attribute(:match, nil)
        end
      else
        match_request.touch
      end
    else
      MatchRequest.create(:league => self, :user => options[:user])
    end
  end
end
