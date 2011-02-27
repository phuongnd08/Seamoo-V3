require 'spec_helper'

describe Bot do
  describe "awake new" do
    it "should awake new bot" do
      Matching.stub(:bot_names).and_return(["abc", "xyz"])
      Bot.awake_new
      Bot.awaken.count.should == 1
      Bot.awaken.first.display_name.should == "abc"
      Bot.awake_new
      Bot.awaken.count.should == 2
      Bot.awaken.last.display_name.should == "xyz"
    end

    it "should return the new awakened bot" do
      Matching.stub(:bot_names).and_return(["abc", "xyz"])
      bot = Bot.awake_new
      bot.is_a?(Bot).should be_true
      Bot.find(bot.id).should == bot
    end

    it "should reset bot information about past match" do
      bot = Bot.awake_new
      Bot.kill(bot)
      bot.data[:match_id] = 1
      bot.data[:match_request_retried] = 5
      new_bot = Bot.awake_new
      new_bot.should == bot
      new_bot.data[:match_id].should == nil
      new_bot.data[:match_request_retried].should == 0
    end
  end

  describe "run" do
    before(:each) do
      Matching.stub(:started_after).and_return(5)
      Matching.stub(:bot_time_per_question).and_return(5)
      Matching.stub(:bot_correctness).and_return(0.8)
      Matching.stub(:ended_after).and_return(300)
      Matching.stub(:questions_per_match).and_return(10)
      @category = Factory(:category)
      @questions = []
      (1..10).each do |t|
        question = Factory(:question, :level => 0, :category => @category)
        question.data.options[0].update_attribute(:correct, true)
        @questions << question
      end
      @league = League.create!(:level => 0, :category => @category)
      @bot = Bot.awake_new
      @now = Time.now
      Time.stub(:now).and_return(@now)
    end

    describe "match_id not obtained" do
      before(:each) do
        @mocked_league = mock_model(League)
        League.stub(:find).with(1).and_return(@mocked_league)
        @bot.data[:league_id] = 1
      end

      it "should try to query for match_id" do
        @mocked_league.should_receive(:request_match).and_return(nil)
        @bot.run
        @match = Match.create(:league => @league)
        @mocked_league.should_receive(:request_match).and_return(@match)
        @bot.run
        @bot.data[:match_id].should == @match.id
      end

      it "should die after maximum retries" do
        Matching.stub(:bot_max_match_request_retries).and_return(3)
        @mocked_league.should_receive(:request_match).exactly(3).and_return(nil)
        Bot.awaken.should include(@bot)
        4.times.each{ @bot.run }
        Bot.awaken.should_not include(@bot)
      end
    end

    describe "match_id obtained" do
      before(:each) do
        @match = Match.create(:league => @league)
        @bot.data[:match_id] = @match.id
        @match_user = MatchUser.create(:match => @match, :user => @bot)
      end
      it "should answer questions at predefined speed" do
        Time.stub(:now).and_return(@now + 4.seconds)
        @bot.run
        @match_user.reload.current_question_position.should == 0
        Time.stub(:now).and_return(@now + 19.seconds)
        @bot.run
        @match_user.reload.current_question_position.should == 3
        Time.stub(:now).and_return(@now + 59.seconds)
        @bot.run
        @match_user.reload.current_question_position.should == 10
      end

      it "should answer questions at predfined correctness" do
        Time.stub(:now).and_return(@now + 59.seconds)
        Bot.stub(:rnd).and_return(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
        @bot.run
        @match_user.reload.current_question_position.should == 10
        @match_user.reload.score.should == 8
      end
    end
  end
end