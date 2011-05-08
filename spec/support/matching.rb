module RSpec
  module Matching
    def start_match(league, users)
      users = users.concat([users[0]])
      users.each_with_index do |user, index|
        # use 3 default questions in order
        if index == users.size - 1
          match = league.matches.first
          Rails.logger.warn("But first league match is nil") if match.nil?
          match.questions.clear
          ::Matching.questions_per_match.times.each do |i|
            match.questions << league.category.questions.all[i]
          end
        end

        Informer.login_as = user.display_name
        visit matching_league_path(@league)
        within "#status" do
          if index==0
            page.should have_content "Waiting for other players"
          else
            page.should have_content "Match started" if index!=0
          end
        end
      end
      league.matches.last
    end
  end
end

RSpec.configure do |config|
  # empty memcache before every spec
  config.include(RSpec::Matching)
end


