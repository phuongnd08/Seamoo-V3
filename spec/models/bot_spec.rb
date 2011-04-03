require 'spec_helper'

describe Bot, :memcached => true do
  describe "avatar" do
    it "should have gravatar like users" do
      Bot.new(:email => "bot@#{Site.domain}").gravatar_url.should_not be_nil
    end
  end

  describe "awake new" do
    it "should awake new bot" do
      Matching.stub(:bots).and_return({"abc" => "Abc User", "xyz" => "xyz"})
      Utils::RndGenerator.stub(:rnd).and_return(1, 0)
      Bot.awake_new
      Bot.awaken.count.should == 1
      Bot.awaken.first.display_name.should == "xyz"
      Bot.awaken.first.email.should == "xyz@#{Site.bot_domain}"
      Bot.awake_new
      Bot.awaken.count.should == 2
      Bot.awaken.last.display_name.should == "Abc User"
      Bot.awaken.last.email.should == "abc@#{Site.bot_domain}"
    end

    it "should return the new awakened bot" do
      Matching.stub(:bots).and_return({"abc" => "abc", "xyz" => "xyz"})
      bot = Bot.awake_new
      bot.is_a?(Bot).should be_true
      Bot.find(bot.id).should == bot
    end

    it "should reset bot information about past match" do
      #make sure same bot will be reused
      Utils::RndGenerator.stub(:rnd).and_return(1)
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
      Matching.started_after #trigger settings logic accessor initilization to prevent re-override rspec stub
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
        debugger
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
        Time.stub(:now).and_return(@now + 6.seconds)
        @bot.run
        @match_user.reload.current_question_position.should == 0
        Time.stub(:now).and_return(@now + 11.seconds)
        @bot.run
        @match_user.reload.current_question_position.should == 1
        Time.stub(:now).and_return(@now + 56.seconds)
        @bot.run
        @match_user.reload.current_question_position.should == 10
      end

      it "should answer questions at predfined correctness" do
        Time.stub(:now).and_return(@now + 59.seconds)
        Utils::RndGenerator.stub(:rnd).and_return(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
        @bot.run
        @match_user.reload.current_question_position.should == 10
        @match_user.reload.score.should == 8
      end

      describe "Match finished" do
        before(:each) do
          Time.stub(:now).and_return(@now + Matching.started_after.seconds + Matching.ended_after.seconds + 1.second)
        end
        it "should die" do
          @bot.run
          Bot.awaken.should_not include(@bot)
        end
      end

      describe "Bot finished" do
        before(:each) do
          @match_user.send(:finished_at=, Time.now)
          @match_user.save
        end
        it "should die" do
          @bot.run
          Bot.awaken.should_not include(@bot)
        end
      end
    end
  end
end
