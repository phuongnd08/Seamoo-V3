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
    def prepare_league_for_match(questions = [])
      ::Matching.started_after #trigger settings class initialization
      ::Matching.stub(:started_after).and_return(0) #all match started immediately

      if questions.empty?
        Factory(:league_with_questions)
      else
        lg = Factory(:league)
        questions.each{ |q| lg.category.questions << q }
        lg
      end
    end

    def assert_recorded_answer(username, position, answer)
      user = User.find_by_display_name(username)
      match_user = MatchUser.find_by_user_id(user.id)
      match = match_user.match
      wait_for_true{
        match_user.reload.answers.has_key?(position)
      }
      realized_answer = match.questions[position].data.realized_answer(match_user.answers[position])
      realized_answer.should == answer
    end
  end
end

RSpec.configure do |config|
  # empty memcache before every spec
  config.include(RSpec::Matching)
end

begin
World(RSpec::Matching)
rescue NoMethodError => e
  # it's ok, cucumber is not loaded
end


