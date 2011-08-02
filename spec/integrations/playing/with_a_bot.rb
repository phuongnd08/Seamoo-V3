require 'spec_helper'

describe "in league playing with bot", :js => true, :caching => true, :asynchronous => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @league = Factory(:league_with_questions)
    MatchingSettings.stub(:questions_per_match).and_return(3) #all match started immediately
    MatchingSettings.stub(:request_bot_after).and_return(1) #all match started immediately
    MatchingSettings.stub(:started_after).and_return(0) #all match started immediately
    MatchingSettings.stub(:bot_time_per_question).and_return(0) #all match started immediately
  end

  it "should see bot as a normal user" do
    EM.run do
      @bot = Factory(:bot)
      Bot.should_receive(:awake_new).and_return(@bot)
      Bot.listen
      Informer.login_as = @mike.display_name
      visit matching_league_path(@league)
      within "#status" do
        page.should have_content("Match started")
      end
      @match_bot = Match.last.match_user_for(@bot)
      wait_for_value 3 do
        @match_bot.reload.current_question_position
      end
      assert_player_indicator(@bot, 3, 3)
      EM.stop
    end
  end
end
