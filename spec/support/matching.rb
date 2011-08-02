module RSpec
  module Matching
    def start_match(league, users)
      users = users.concat([users[0]])
      users.each_with_index do |user, index|
        # use 3 default questions in order
        if index == users.size - 1
          match = league.matches.first
          match.questions.clear
          ::MatchingSettings.questions_per_match.times.each do |i|
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
      ::MatchingSettings.stub(:started_after).and_return(0) #all match started immediately
      league = Factory(:league)
      questions.each{ |q| league.category.questions << q }
      league
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

    def assert_player_indicator(user, position, total)
      within "#match_players" do
        selector = if (position < total)
                     "img[title='#{user.display_name} (#{position+1}/#{total})']"
                   else
                     "img[title='#{user.display_name} (finished)']"
                   end
        page.should have_css(selector)

        img_width = page.evaluate_script(%{$("#match_players #{selector}").width()}).to_f
        lane_width = page.evaluate_script(%{$("#match_players #{selector}").parent("li").width()}).to_f
        margin = position.to_f/total*(lane_width-img_width)
        page.evaluate_script(%{$("#match_players #{selector}").css('marginLeft')}).to_f.should be_within(0.1).of(margin)
      end
    end
  end
end

RSpec.configure do |config|
  # empty memcache before every spec
  config.include(RSpec::Matching)
  config.before(:each) do
    visit root_path if example.metadata[:asynchronous]
  end
end

begin
  World(RSpec::Matching)
rescue NoMethodError => e
  # it's ok, cucumber is not loaded
end


